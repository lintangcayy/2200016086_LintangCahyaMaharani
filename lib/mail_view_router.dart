import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reply/custom_transition_page.dart';
import 'package:animations/animations.dart';
import 'home.dart';
import 'inbox.dart';
import 'model/email_store.dart';

class MailViewRouterDelegate extends RouterDelegate<void>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  MailViewRouterDelegate({required this.drawerController});

  final AnimationController drawerController;

  @override
  GlobalKey<NavigatorState> get navigatorKey => mobileMailNavKey;

  @override
  Widget build(BuildContext context) {
    return Selector<EmailStore, String>(
      selector: (context, emailStore) => emailStore.currentlySelectedInbox,
      builder: (context, currentlySelectedInbox, child) {
        return Navigator(
          key: navigatorKey,
          onPopPage: _handlePopPage,
          pages: [
            FadeThroughTransitionPageWrapper(
              mailbox: InboxPage(destination: currentlySelectedInbox),
              transitionKey: ValueKey(currentlySelectedInbox),
            ),
          ],
        );
      },
    );
  }

  bool _handlePopPage(Route<dynamic> route, dynamic result) {
    return false;
  }

  @override
  Future<bool> popRoute() async {
    var emailStore =
        Provider.of<EmailStore>(navigatorKey.currentContext!, listen: false);
    bool onCompose = emailStore.onCompose;
    bool onMailView = emailStore.onMailView;

    if (!(onMailView || onCompose)) {
      if (emailStore.bottomDrawerVisible) {
        drawerController.reverse();
        return true;
      }

      if (emailStore.currentlySelectedInbox != 'Inbox') {
        emailStore.currentlySelectedInbox = 'Inbox';
        return true;
      }
      return false;
    }

    if (onCompose) {
      return true;
    }

    if (emailStore.bottomDrawerVisible && onMailView) {
      drawerController.reverse();
      return true;
    }

    if (navigatorKey.currentState!.canPop()) {
      navigatorKey.currentState!.pop();
      Provider.of<EmailStore>(navigatorKey.currentContext!, listen: false)
          .currentlySelectedEmailId = -1;
      return true;
    }

    return false;
  }

  @override
  Future<void> setNewRoutePath(void configuration) async {
    // This function will never be called.
    throw UnimplementedError();
  }
}

class FadeThroughTransitionPageWrapper extends Page {
  const FadeThroughTransitionPageWrapper({
    required this.mailbox,
    required this.transitionKey,
  }) : super(key: transitionKey);

  final Widget mailbox;
  final ValueKey transitionKey;

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeThroughTransition(
          fillColor: Theme.of(context).scaffoldBackgroundColor,
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          child: child,
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return mailbox;
      },
    );
  }
}
