
// lib/screens/webview_screen.dart (Enhanced Version)
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'dart:io';
import '../widgets/no_internet_widget.dart';
import '../services/session_manager.dart';

class WebViewScreen extends StatefulWidget {
  final String url;
  final String title;

  const WebViewScreen({
    super.key,
    required this.url,
    required this.title,
  });

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen>
    with AutomaticKeepAliveClientMixin {
  late final WebViewController _controller;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = true;
  bool _hasInternet = true;
  String _currentTitle = '';
  int _loadingProgress = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
    _checkConnectivity();
    _setupConnectivityListener();
  }

  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              _loadingProgress = progress;
              _isLoading = progress < 100;
            });
          },
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
              _loadingProgress = 0;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
              _loadingProgress = 100;
            });
            _updateTitle();
            SessionManager.saveCookies(_controller);
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              _isLoading = false;
            });
            if (error.errorType == WebResourceErrorType.hostLookup ||
                error.errorType == WebResourceErrorType.timeout) {
              _checkConnectivity();
            }
          },
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..enableZoom(true)
      ..setUserAgent(
          'Mozilla/5.0 (Linux; Android 13; SM-G981B) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Mobile Safari/537.36'
      );

    // Setup file upload handling
    _setupFileUploadHandling();

    // Restore session and load URL
    _loadWithSession();
  }

  void _setupFileUploadHandling() {
    _controller.setOnConsoleMessage((JavaScriptConsoleMessage message) {
      print('Console: ${message.message}');
    });
  }

  Future<void> _loadWithSession() async {
    await SessionManager.restoreCookies(_controller);
    if (_hasInternet) {
      await _controller.loadRequest(Uri.parse(widget.url));
    }
  }
  Future<void> _checkConnectivity() async {
    final connectivity = await Connectivity().checkConnectivity();
    final hasConnection = connectivity != ConnectivityResult.none;

    if (mounted) {
      setState(() {
        _hasInternet = hasConnection;
      });
    }
  }

  void _setupConnectivityListener() {
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((result) {
          final hasConnection = result != ConnectivityResult.none;

          if (hasConnection != _hasInternet && mounted) {
            setState(() {
              _hasInternet = hasConnection;
            });

            if (hasConnection) {
              _retryLoad();
            }
          }
        });
  }


  Future<void> _updateTitle() async {
    try {
      final title = await _controller.getTitle();
      if (title != null && title.isNotEmpty && mounted) {
        setState(() {
          _currentTitle = title;
        });
      }
    } catch (e) {
      print('Error updating title: $e');
    }
  }

  Future<void> _retryLoad() async {
    if (_hasInternet) {
      setState(() {
        _isLoading = true;
        _loadingProgress = 0;
      });
      try {
        await _controller.loadRequest(Uri.parse(widget.url));
      } catch (e) {
        print('Error loading URL: $e');
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _refresh() async {
    if (_hasInternet) {
      setState(() {
        _isLoading = true;
        _loadingProgress = 0;
      });
      try {
        await _controller.reload();
      } catch (e) {
        print('Error refreshing: $e');
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      _checkConnectivity();
    }
  }

  Future<void> _handleFileUpload() async {
    try {
      // Request storage permission
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        status = await Permission.storage.request();
      }

      if (status.isGranted) {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          allowMultiple: false,
          type: FileType.any,
        );

        if (result != null && result.files.single.path != null) {
          // File selected successfully
          final file = File(result.files.single.path!);
          print('File selected: ${file.path}');

          // Show success message
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('File selected: ${result.files.single.name}'),
                backgroundColor: Colors.green,
              ),
            );
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Storage permission required for file uploads'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      print('Error picking file: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error selecting file'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600,color: Colors.white),
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
        actions: [
          // IconButton(
          //   icon: const Icon(Icons.attach_file),
          //   onPressed: _handleFileUpload,
          //   tooltip: 'Upload File',
          // ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _refresh,
            tooltip: 'Refresh',
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: ()  {
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'My App Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context); // close drawer
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          if (!_hasInternet)
            NoInternetWidget(
              onRetry: _retryLoad,
            )
          else
            RefreshIndicator(
              onRefresh: _refresh,
              child: WebViewWidget(controller: _controller),
            ),

          // Loading indicator
          if (_isLoading && _hasInternet)
            Column(
              children: [
                LinearProgressIndicator(
                  value: _loadingProgress / 100,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor,
                  ),
                ),
                const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }
}
