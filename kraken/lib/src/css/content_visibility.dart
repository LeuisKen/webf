/*
 * Copyright (C) 2019-present Alibaba Inc. All rights reserved.
 * Author: Kraken Team.
 */
import 'package:kraken/css.dart';
import 'package:kraken/element.dart';
import 'package:kraken/rendering.dart';

// CSS Content Visibility: https://www.w3.org/TR/css-contain-2/#content-visibility

enum ContentVisibility {
  auto,
  hidden,
  visible
}

mixin CSSContentVisibilityMixin on ElementBase {
  bool _hasIntersectionObserver = false;

  void setContentVisibilityIntersectionObserver(
    RenderBoxModel renderBoxModel, ContentVisibility contentVisibility) {
    if (contentVisibility == ContentVisibility.auto && !_hasIntersectionObserver) {
      renderBoxModel.addIntersectionChangeListener(_handleIntersectionChange);
      // Call needs paint make sure intersection observer works immediately
      renderBoxModel.markNeedsPaint();
      _hasIntersectionObserver = true;
    }
  }

  static ContentVisibility getContentVisibility(String value) {
    if (value == null) return ContentVisibility.visible;

    switch(value) {
      case HIDDEN:
        return ContentVisibility.hidden;
      case AUTO:
        return ContentVisibility.auto;
      case VISIBLE:
      default:
        return ContentVisibility.visible;
    }
  }

  void _handleIntersectionChange(IntersectionObserverEntry entry) {
    assert(renderBoxModel != null);
    renderBoxModel.contentVisibility = entry.isIntersecting
        ? ContentVisibility.auto
        : ContentVisibility.hidden;
  }

  void updateRenderContentVisibility(ContentVisibility contentVisibility) {
    if (renderBoxModel != null) {
      renderBoxModel.contentVisibility = contentVisibility;
      if (contentVisibility != ContentVisibility.auto && _hasIntersectionObserver) {
        renderBoxModel.removeIntersectionChangeListener(_handleIntersectionChange);
        _hasIntersectionObserver = false;
      }
      setContentVisibilityIntersectionObserver(renderBoxModel, contentVisibility);
    }
  }
}
