import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

Future<bool> requestPermissionToGallery() async {
  var permission = Platform.isAndroid
      ? await Permission.mediaLibrary.request()
      : Permission.photos.request();

  return permission;
}

Future<bool> hasGalleryWritePermission() async {
  var permission = Platform.isAndroid
      ? await Permission.storage.request()
      : Permission.photos.request();

  return permission;
}

// class PermissionsService {
//   final PermissionsService _permissionHandler = PermissionsService();

//   Future<bool> _requestPermission(Permission permission) async {
//     var result = await _permissionHandler._requestPermission(permission);

//     if (result == PermissionStatus.granted) {
//       return false;
//     }

//     return true;
//   }

//   /// Requests the user permission to save photos and videos to the Gallery
//   /// For Android, ExternalStorage, For iOS, Photos

//   /// Check if the has permission to save photos to user gallery
//   /// For Android, ExternalStorage, For iOS, Photos

//   Future<bool> hasPermission(Future<PermissionStatus> permission) async {
//     var permissionStatus = PermissionsService();

//     return permissionStatus == PermissionStatus.denied;
//   }
// }
