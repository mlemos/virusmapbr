import 'dart:typed_data';
import 'dart:ui';
import 'package:crop/crop.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:provider/provider.dart';
import 'package:virusmapbr/components/virusmapbr_icons.dart';
import 'package:virusmapbr/helpers/inverted_circle_clipper.dart';
import 'package:virusmapbr/helpers/logger.dart';
import 'package:virusmapbr/providers/session_provider.dart';
import 'package:virusmapbr/themes/themes.dart';
import 'package:uuid/uuid.dart';

class EditAvatar extends StatefulWidget {
  @override
  _EditAvatarState createState() => _EditAvatarState();
}

class _EditAvatarState extends State<EditAvatar> {
  final _cropController = CropController(aspectRatio: 1000 / 1000);
  final _imagePicker = ImagePicker();
  File _avatarFile;
  SessionProvider _sessionProvider;
  String _uploadedFileURL;
  StorageUploadTask _uploadTask;

  @override
  void initState() {
    super.initState();
    _sessionProvider = Provider.of<SessionProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VirusMapBRTheme.color(context, "surface"),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildProgressIndicator(),
            _buildStatusPanel(),
            _buildControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusPanel() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildBackButton(),
            _buildImageEditor(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    if (_uploadTask != null) {
      return StreamBuilder<StorageTaskEvent>(
        stream: _uploadTask.events,
        builder: (context, snapshot) {
          var event = snapshot?.data?.snapshot;
          double progressPercent =
              event != null ? event.bytesTransferred / event.totalByteCount : 0;
          return Column(
            children: [
              if (_uploadTask.isInProgress && progressPercent < 0.1)
                LinearProgressIndicator(),
              if (_uploadTask.isInProgress && progressPercent >= 0.1)
                Container(
                  height: 6.0,
                  child: LinearProgressIndicator(value: progressPercent),
                ),
              if (_uploadTask.isComplete)
                Container(
                  color: VirusMapBRTheme.color(context, "primary"),
                  height: 6.0,
                ),
            ],
          );
        },
      );
    } else {
      return Container(color: Colors.transparent, height: 6.0);
    }
  }

  Widget _buildBackButton() {
    return Row(
      children: [
        Container(
          height: 32.0,
          width: 32.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: VirusMapBRTheme.color(context, "modal").withOpacity(0.2),
          ),
          child: Center(
            child: IconButton(
              padding: EdgeInsets.all(0),
              color: VirusMapBRTheme.color(context, "white"),
              icon: Icon(VirusMapBRIcons.return_icon),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
          ),
        )
      ],
    );
  }

  Expanded _buildImageEditor() {
    return Expanded(
      child: Center(
        child: Container(
          width: 248,
          height: 248,
          child: Crop(
            controller: _cropController,
            child: (_avatarFile != null)
                ? Image.file(_avatarFile)
                : Container(height: 15),
            backgroundColor:
                VirusMapBRTheme.color(context, "black").withOpacity(0.8),
            background: Center(
                child: Text(
              "Escolha uma foto",
              style: Theme.of(context)
                  .textTheme
                  .headline3
                  .merge(TextStyle(color: VirusMapBRTheme.color(context, "white"))),
            )),
            helper: Stack(
              children: [
                IgnorePointer(
                  child: ClipPath(
                    clipper: InvertedCircleClipper(),
                    child: Container(
                      color: VirusMapBRTheme.color(context, "surface"),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildControls() {
    return Container(
      padding: EdgeInsets.fromLTRB(24.0, 32.0, 24.0, 32.0),
      decoration: BoxDecoration(
        color: VirusMapBRTheme.color(context, "modal"),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.0),
          topRight: Radius.circular(12.0),
        ),
        boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 10)],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                (_avatarFile == null) ? _buildCameraButton() : Container(),
                (_avatarFile != null)
                    ? _buildChangeAvatarButton()
                    : Container(),
                SizedBox(height: 24.0),
                (_avatarFile != null) ? _buildConfirmButton() : Container(),
                (_avatarFile == null) ? _buildGalleryButton() : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Build the form submit button
  Widget _buildCameraButton() {
    return Container(
      height: 56.0,
      child: Row(
        children: [
          Expanded(
            child: RaisedButton(
              elevation: 0,
              color: VirusMapBRTheme.color(context, "modal"),
              shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: VirusMapBRTheme.color(context, "text4"), width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              child: Center(
                  child: Text(
                "Tirar foto",
                style: Theme.of(context).textTheme.headline3.merge(
                    TextStyle(color: VirusMapBRTheme.color(context, "text3"))),
              )),
              onPressed: _takePicture,
            ),
          ),
        ],
      ),
    );
  }

  // Build the form submit button
  Widget _buildGalleryButton() {
    return Container(
      height: 56.0,
      child: Row(
        children: [
          Expanded(
            child: RaisedButton(
              elevation: 0,
              color: VirusMapBRTheme.color(context, "modal"),
              shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: VirusMapBRTheme.color(context, "text4"), width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              child: Center(
                  child: Text(
                "Escolher da galeria",
                style: Theme.of(context).textTheme.headline3.merge(
                    TextStyle(color: VirusMapBRTheme.color(context, "text3"))),
              )),
              onPressed: _chooseFromGallery,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChangeAvatarButton() {
    return Container(
      height: 56.0,
      child: Row(
        children: [
          Expanded(
            child: RaisedButton(
              elevation: 0,
              color: VirusMapBRTheme.color(context, "modal"),
              shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: VirusMapBRTheme.color(context, "text4"), width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              child: Center(
                  child: Text(
                "Alterar foto do perfil",
                style: Theme.of(context).textTheme.headline3.merge(
                    TextStyle(color: VirusMapBRTheme.color(context, "text3"))),
              )),
              onPressed: () {
                setState(() {
                  _avatarFile = null;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton() {
    return Container(
      height: 56.0,
      child: Row(
        children: [
          Expanded(
            child: RaisedButton(
              elevation: 8.0,
              color: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              child: Center(
                  child: Text(
                "Confirmar",
                style: Theme.of(context).textTheme.headline3.merge(
                    TextStyle(color: VirusMapBRTheme.color(context, "white"))),
              )),
              onPressed: _cropAndUploadAvatar,
            ),
          ),
        ],
      ),
    );
  }

  Future _chooseFromGallery() async {
    await _imagePicker
        .getImage(
      source: ImageSource.gallery,
      maxHeight: 600,
      maxWidth: 600,
    )
        .then(
      (pickedFile) {
        setState(
          () {
            _resetCropController();
            _avatarFile = File(pickedFile.path);
          },
        );
      },
    );
  }

  Future _takePicture() async {
    await _imagePicker
        .getImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
      maxHeight: 600,
      maxWidth: 600,
    )
        .then(
      (pictureTaken) {
        setState(
          () {
            _resetCropController();
            _avatarFile = File(pictureTaken.path);
          },
        );
      },
    );
  }

  void _resetCropController() {
    _cropController.rotation = 0;
    _cropController.scale = 1;
    _cropController.offset = Offset.zero;
  }

  void _cropAndUploadAvatar() async {
    final pixelRatio = MediaQuery.of(context).devicePixelRatio;
    final croppedAvatar = await _cropController.crop(pixelRatio: pixelRatio);
    var croppedAvatarByteData =
        await croppedAvatar.toByteData(format: ImageByteFormat.png);
    var croppedAvatarBuffer = croppedAvatarByteData.buffer.asUint8List();
    var finalCroppedAvataView = Uint8List.view(croppedAvatarBuffer.buffer);
    final Directory systemTempDir = Directory.systemTemp;
    var uuid = Uuid();
    var filename = uuid.v4();
    final File file =
        await File('${systemTempDir.path}/$filename.png').create();
    await file.writeAsBytes(finalCroppedAvataView);

    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('avatars/${Path.basename(file.path)}');
    setState(() {
      _uploadTask = storageReference.putFile(file);
    });
    await _uploadTask.onComplete;
    Logger.cyan('EditAvatar >> Avatar uploaded.');
    _uploadedFileURL = await storageReference.getDownloadURL();
    Logger.cyan('EditAvatar >> .. photoUrl: $_uploadedFileURL');
    await _sessionProvider.session.updatePhotoUrl(_uploadedFileURL);
    _sessionProvider.notify();
    Navigator.pop(context);
  }
}
