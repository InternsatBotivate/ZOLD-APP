import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import '../constants/api_constants.dart';
import './auth_service.dart';
import '../utils/app_logger.dart';

class SocketService extends GetxService {
  static SocketService get to => Get.find();

  io.Socket? _socket;

  bool get isConnected => _socket?.connected ?? false;

  Future<SocketService> init() async {
    _initSocket();
    _setupAuthListener();
    return this;
  }

  void _setupAuthListener() {
    ever(AuthService.to.user, (user) {
      if (user != null) {
        _joinUserRoom();
      }
    });
  }

  void _initSocket() {
    try {
      final socketUrl = ApiConstants.baseUrl.replaceAll('/api', '');
      AppLogger.i('Initializing Socket at: $socketUrl');

      _socket = io.io(socketUrl, <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
        'reconnection': true,
        'reconnectionAttempts': 5,
        'reconnectionDelay': 1000,
        'timeout': 10000,
      });

      _socket?.onConnect((_) {
        AppLogger.i('Socket connected');
        _joinUserRoom();
      });

      _socket?.onDisconnect((_) => AppLogger.i('Socket disconnected'));

      _socket?.onConnectError((err) => AppLogger.e('Socket Connect Error: $err'));
      
      _socket?.onError((err) => AppLogger.e('Socket Error: $err'));

      _socket?.connect();
    } catch (e) {
      AppLogger.e('Socket initialization failed', e);
    }
  }

  void _joinUserRoom() {
    try {
      final userId = AuthService.to.user.value?.id;
      if (userId != null && isConnected) {
        AppLogger.i('Joining room: $userId');
        _socket?.emit('joinRoom', userId);
      }
    } catch (e) {
      AppLogger.e('Socket joinRoom error', e);
    }
  }

  void emit(String event, dynamic data) {
    if (isConnected) {
      _socket?.emit(event, data);
    } else {
      AppLogger.w('Cannot emit $event: Socket not connected');
    }
  }

  void on(String event, Function(dynamic) handler) {
    _socket?.on(event, handler);
  }

  void off(String event, [Function(dynamic)? handler]) {
    _socket?.off(event, handler);
  }

  void reconnect() {
    _socket?.disconnect();
    _socket?.connect();
  }

  @override
  void onClose() {
    _socket?.dispose();
    super.onClose();
  }
}
