// Copyright 2016 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// This is a temporary top-level module for testing the other two youtube
// modules (youtube_thumbnail, youtube_video) with a pre-populated video id.
// You can run this by modifying the module url in the dummy_user_shell or
// email_user_shell to be "file:///system/apps/youtube_story".
// TODO(youngseokyoon): Remove this module later.

import 'package:apps.modular.lib.app.dart/app.dart';
import 'package:apps.modular.services.application/service_provider.fidl.dart';
import 'package:apps.modular.services.document_store/document.fidl.dart';
import 'package:apps.modular.services.story/link.fidl.dart';
import 'package:apps.modular.services.story/module.fidl.dart';
import 'package:apps.modular.services.story/module_controller.fidl.dart';
import 'package:apps.modular.services.story/story.fidl.dart';
import 'package:apps.mozart.lib.flutter/child_view.dart';
import 'package:apps.mozart.services.views/view_token.fidl.dart';
import 'package:flutter/material.dart';
import 'package:lib.fidl.dart/bindings.dart';

final ApplicationContext _context = new ApplicationContext.fromStartupInfo();

final GlobalKey<HomeScreenState> _kHomeKey = new GlobalKey<HomeScreenState>();

final String _kYoutubeDocId = 'youtube-doc';
final String _kYoutubeVideoIdKey = 'youtube-video-id';

final String _kChildUrl = 'file:///system/apps/youtube_thumbnail';
// final String _kChildUrl = 'file:///system/apps/youtube_video';

// The youtube video id.
final String _kVideoId = 'p336IIjZCl8';

ChildViewConnection _conn;

void _log(String msg) {
  print('[youtube_story] $msg');
}

/// An implementation of the [Module] interface.
class ModuleImpl extends Module {
  final ModuleBinding _binding = new ModuleBinding();

  /// [Story] service provided by the framework.
  final StoryProxy story = new StoryProxy();

  /// [Link] service provided by the framework.
  final LinkProxy link = new LinkProxy();

  /// Bind an [InterfaceRequest] for a [Module] interface to this object.
  void bind(InterfaceRequest<Module> request) {
    _binding.bind(this, request);
  }

  @override
  void initialize(
    InterfaceHandle<Story> storyHandle,
    InterfaceHandle<Link> linkHandle,
    InterfaceHandle<ServiceProvider> incomingServicesHandle,
    InterfaceRequest<ServiceProvider> outgoingServices,
  ) {
    _log('ModuleImpl::initialize call');

    story.ctrl.bind(storyHandle);

    // Bind the link handle and write the video id.
    link.ctrl.bind(linkHandle);

    Document youtubeDoc = new Document.init(
      _kYoutubeDocId,
      <String, Value>{
        _kYoutubeVideoIdKey: new Value()..stringValue = _kVideoId
      },
    );

    link.addDocuments(<String, Document>{
      _kYoutubeDocId: youtubeDoc,
    });

    // Spawn the child.
    _conn = new ChildViewConnection(startModule(url: _kChildUrl));
    _kHomeKey.currentState?.updateUI();
  }

  @override
  void stop(void callback()) {
    _log('ModuleImpl::stop call');
    story.ctrl.close();
    link.ctrl.close();
    callback();
  }

  /// Start a module and return its [ViewOwner] handle.
  InterfaceHandle<ViewOwner> startModule({
    String url,
    InterfaceHandle<ServiceProvider> outgoingServices,
    InterfaceRequest<ServiceProvider> incomingServices,
  }) {
    ViewOwnerProxy viewOwner = new ViewOwnerProxy();
    ModuleControllerProxy moduleController = new ModuleControllerProxy();

    _log('Starting sub-module: $url');
    story.startModule(
      url,
      duplicateLink(link),
      outgoingServices,
      incomingServices,
      moduleController.ctrl.request(),
      viewOwner.ctrl.request(),
    );
    _log('Started sub-module: $url');

    // Close this to prevent leaks.
    moduleController.ctrl.close();

    return viewOwner.ctrl.unbind();
  }

  /// Obtains a duplicated [InterfaceHandle] for the given [Link] object.
  InterfaceHandle<Link> duplicateLink(Link link) {
    LinkProxy linkProxy = new LinkProxy();
    link.dup(linkProxy.ctrl.request());
    return linkProxy.ctrl.unbind();
  }
}

/// Main screen for this module.
class HomeScreen extends StatefulWidget {
  /// Creates a new instance of [HomeScreen].
  HomeScreen({Key key}) : super(key: key);

  @override
  HomeScreenState createState() => new HomeScreenState();
}

/// State class for the main screen widget.
class HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return new Container(
      alignment: FractionalOffset.center,
      constraints: const BoxConstraints.expand(),
      child: _conn != null
          ? new ChildView(connection: _conn)
          : new CircularProgressIndicator(),
    );
  }

  /// Convenient method for other entities to call setState to cause UI updates.
  void updateUI() {
    setState(() {});
  }
}

/// Main entry point to the email folder list module.
void main() {
  _log('Module started with context: $_context');

  /// Add [ModuleImpl] to this application's outgoing ServiceProvider.
  _context.outgoingServices.addServiceForName(
    (InterfaceRequest<Module> request) {
      _log('Received binding request for Module');
      new ModuleImpl().bind(request);
    },
    Module.serviceName,
  );

  runApp(new MaterialApp(
    title: 'Youtube Story',
    home: new HomeScreen(key: _kHomeKey),
    theme: new ThemeData(primarySwatch: Colors.blue),
    debugShowCheckedModeBanner: false,
  ));
}