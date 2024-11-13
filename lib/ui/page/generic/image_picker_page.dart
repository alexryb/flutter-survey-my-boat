import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:image_picker/image_picker.dart';
import 'package:surveymyboatpro/di/dependency_injection.dart';
import 'package:surveymyboatpro/model/checkpoint.dart';
import 'package:surveymyboatpro/model/checkpoint_status.dart';
import 'package:surveymyboatpro/model/client.dart';
import 'package:surveymyboatpro/model/container_image.dart';
import 'package:surveymyboatpro/model/image_container.dart';
import 'package:surveymyboatpro/model/survey.dart';
import 'package:surveymyboatpro/model/surveyor.dart';
import 'package:surveymyboatpro/model/vessel.dart';
import 'package:surveymyboatpro/ui/page/profile/profile_edit_page.dart';
import 'package:surveymyboatpro/ui/page/survey/checkpoint_page.dart';
import 'package:surveymyboatpro/ui/page/survey/vessel_page.dart';
import 'package:surveymyboatpro/ui/page/surveyor/client/client_detail_page.dart';
import 'package:uuid/uuid.dart';
import 'package:video_player/video_player.dart';

class ImagePickerPage extends StatefulWidget {

  String? title;
  Survey? survey;
  Map<String, List<DropdownMenuItem<String>>>? codes;
  ImageContainer? imageContainer;

  ImagePickerPage.withSurveyImageContainer({
          this.title, 
          this.survey, 
          this.imageContainer, 
          this.codes});

  ImagePickerPage.withImageContainer({
    this.title,
    this.imageContainer});
  

  @override
  _ImagePickerPageState createState() => _ImagePickerPageState();
}

class _ImagePickerPageState extends State<ImagePickerPage> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  XFile? _imageFile;
  dynamic _pickImageError;
  bool? isVideo = false;
  VideoPlayerController? _controller;
  VideoPlayerController? _toBeDisposed;
  String? _retrieveDataError;

  final ImagePicker _picker = ImagePicker();
  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();

  Future<void> _playVideo(XFile file) async {
    if (file != null && mounted) {
      await _disposeVideoController();
      if (kIsWeb) {
        _controller = VideoPlayerController.networkUrl(Uri.file(file.path));
        // In web, most browsers won't honor a programmatic call to .play
        // if the video has a sound track (and is not muted).
        // Mute the video so it auto-plays in web!
        // This is not needed if the call to .play is the result of user
        // interaction (clicking on a "play" button, for example).
        await _controller?.setVolume(0.0);
      } else {
        _controller = VideoPlayerController.file(File(file.path));
        await _controller?.setVolume(1.0);
      }
      await _controller?.initialize();
      await _controller?.setLooping(true);
      await _controller?.play();
      setState(() {});
    }
  }

  void _onImageButtonPressed(ImageSource source, {required BuildContext context}) async {
    if (_controller != null) {
      await _controller?.setVolume(0.0);
    }
    if (isVideo!) {
      final XFile file = (await _picker.pickVideo(
          source: source, maxDuration: const Duration(seconds: 10))) as XFile;
      await _playVideo(file);
    } else {
      await _onPickCall(context,
          (double maxWidth, double maxHeight, int quality) async {
        try {
          final pickedFile = await _picker.pickImage(
            source: source,
            maxWidth: maxWidth,
            maxHeight: maxHeight,
            imageQuality: quality,
          );
          setState(() {
            _imageFile = pickedFile;
          });
        } catch (e) {
          setState(() {
            _pickImageError = e;
          });
        }
        await _addImage();
        _setImageContainerStatus();
      });
    }
  }

  @override
  void deactivate() {
    if (_controller != null) {
      _controller?.setVolume(0.0);
      _controller?.pause();
    }
    super.deactivate();
  }

  @override
  void dispose() {
    _disposeVideoController();
    maxWidthController.dispose();
    maxHeightController.dispose();
    qualityController.dispose();
    super.dispose();
  }

  Future<void> _disposeVideoController() async {
    if (_toBeDisposed != null) {
      await _toBeDisposed?.dispose();
    }
    _toBeDisposed = _controller;
    _controller = null;
  }

  Widget _previewVideo() {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_controller == null) {
      return const Text(
        'You have not yet picked a video',
        textAlign: TextAlign.center,
      );
    }
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: AspectRatioVideo(_controller!),
    );
  }

  Widget _previewImage() {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_imageFile != null) {
      if (kIsWeb) {
        // Why network?
        // See https://pub.dev/packages/image_picker#getting-ready-for-the-web-platform
        return Image.network(_imageFile!.path);
      } else {
        return Image.file(File(_imageFile!.path));
      }
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return const Text(
        'You have not yet picked an image.',
        textAlign: TextAlign.center,
      );
    }
  }

  Future<void> retrieveLostData() async {
    LostDataResponse response = (await _picker.retrieveLostData());
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      if (response.type == RetrieveType.video) {
        isVideo = true;
        await _playVideo(response.file!);
      } else {
        isVideo = false;
        setState(() {
          _imageFile = response.file;
        });
      }
    } else {
      _retrieveDataError = response.exception?.code;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new PopScope(
      onPopInvokedWithResult: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title!),
          leading: new Builder(builder: (context) {
            return IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                _navigateToNextPage();
              },
            );
          }), systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        body: Center(
          child: !kIsWeb && defaultTargetPlatform == TargetPlatform.android
              ? FutureBuilder<void>(
                  future: retrieveLostData(),
                  builder:
                      (BuildContext context, AsyncSnapshot<void> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return const Text(
                          'You have not yet picked an image.',
                          textAlign: TextAlign.center,
                        );
                      case ConnectionState.done:
                        return isVideo! ? _previewVideo() : _previewImage();
                      default:
                        if (snapshot.hasError) {
                          return Text(
                            'Pick image/video error: ${snapshot.error}}',
                            textAlign: TextAlign.center,
                          );
                        } else {
                          return const Text(
                            'You have not yet picked an image.',
                            textAlign: TextAlign.center,
                          );
                        }
                    }
                  },
                )
              : (isVideo! ? _previewVideo() : _previewImage()),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton(
              backgroundColor: Colors.blueGrey,
              foregroundColor: Colors.white,
              onPressed: () {
                isVideo = false;
                _onImageButtonPressed(ImageSource.gallery, context: context);
              },
              heroTag: 'image0',
              tooltip: 'Pick Image from gallery',
              child: const Icon(Icons.photo_library),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: FloatingActionButton(
                backgroundColor: Colors.blueGrey,
                foregroundColor: Colors.white,
                onPressed: () {
                  isVideo = false;
                  _onImageButtonPressed(ImageSource.camera, context: context);
                },
                heroTag: 'image1',
                tooltip: 'Take a Photo',
                child: const Icon(Icons.camera_alt),
              ),
            ),
            Visibility(
              visible: false,
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: FloatingActionButton(
                  backgroundColor: Colors.blueGrey,
                  foregroundColor: Colors.white,
                  onPressed: () {
                    isVideo = true;
                    _onImageButtonPressed(ImageSource.gallery, context: context);
                  },
                  heroTag: 'video0',
                  tooltip: 'Pick Video from gallery',
                  child: const Icon(Icons.video_library),
                ),
              ),
            ),
            Visibility(
              visible: false,
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: FloatingActionButton(
                  backgroundColor: Colors.blueGrey,
                  foregroundColor: Colors.white,
                  onPressed: () {
                    isVideo = true;
                    _onImageButtonPressed(ImageSource.camera, context: context);
                  },
                  heroTag: 'video1',
                  tooltip: 'Take a Video',
                  child: const Icon(Icons.videocam),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  Future<void> _onPickCall(BuildContext context, OnPickImageCallback onPick) async {
    onPick(Injector.SETTINGS!.cameraWidth!.toDouble(), Injector.SETTINGS!.cameraHeigth!.toDouble(), 0);
    return;
  }

  Future<void> _addImage() async {
    if(_imageFile != null) {
      Uint8List imgBinary = await _imageFile!.readAsBytes();
      ContainerImage containerImage = new ContainerImage.Named(
          Uuid().v4().toString().toUpperCase().replaceAll("-", ''),
          widget.imageContainer?.getName(),
          widget.imageContainer?.getName(),
          "image/png",
          imgBinary);
      widget.imageContainer?.addImage(containerImage);
    }
    return;
  }

  void _setImageContainerStatus() {
    if (widget.imageContainer is CheckPoint) {
      CheckPoint cp = widget.imageContainer as CheckPoint;
      cp.status = CheckPointStatus.UnCompleted();
    }
  }

  void _onBackPressed(bool val, dynamic Object) {
    _navigateToNextPage();
  }

  void _navigateToNextPage() {
    if (widget.imageContainer is CheckPoint) {
      CheckPoint cp = widget.imageContainer as CheckPoint;
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => CheckPointPage.withSurvey(
                  survey: widget.survey!, checkPoint: cp, codes: widget.codes)), (r) => true);
    }
    if (widget.imageContainer is Vessel) {
      Vessel v = widget.imageContainer as Vessel;
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => VesselPage.withSurvey(
                  survey: widget.survey!, codes: widget.codes!)), (r) => true);
    }
    if (widget.imageContainer is Surveyor) {
      Surveyor s = widget.imageContainer as Surveyor;
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => ProfileEditPage.withUser(s)), (r) => true);
    }
    if (widget.imageContainer is Client) {
      Client c = widget.imageContainer as Client;
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => ClientDetailPage(key: _formKey, client: c)), (r) => true);
    }
  }
}

typedef void OnPickImageCallback(
    double maxWidth, double maxHeight, int quality);

class AspectRatioVideo extends StatefulWidget {
  AspectRatioVideo(this.controller);

  final VideoPlayerController controller;

  @override
  AspectRatioVideoState createState() => AspectRatioVideoState();
}

class AspectRatioVideoState extends State<AspectRatioVideo> {
  VideoPlayerController get controller => widget.controller;
  bool initialized = false;

  void _onVideoControllerUpdate() {
    if (!mounted) {
      return;
    }
    if (initialized != controller.value.isInitialized) {
      initialized = controller.value.isInitialized;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    controller.addListener(_onVideoControllerUpdate);
  }

  @override
  void dispose() {
    controller.removeListener(_onVideoControllerUpdate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (initialized) {
      return Center(
        child: AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: VideoPlayer(controller),
        ),
      );
    } else {
      return Container();
    }
  }
}
