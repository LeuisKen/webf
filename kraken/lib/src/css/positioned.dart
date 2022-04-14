/*
 * Copyright (C) 2021-present The Kraken authors. All rights reserved.
 */

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:kraken/css.dart';
import 'package:kraken/dom.dart';
import 'package:kraken/rendering.dart';

// CSS Positioned Layout: https://drafts.csswg.org/css-position/

// RenderPositionHolder may be affected by overflow: scroller offset.
// We need to reset these offset to keep positioned elements render at their original position.
// @NOTE: Attention that renderObjects in tree may not all subtype of RenderBoxModel, use `is` to identify.
Offset? _getRenderPositionHolderScrollOffset(RenderPositionPlaceholder holder, RenderObject root) {
  AbstractNode? current = holder.parent;
  while (current != null && current != root) {
    if (current is RenderBoxModel) {
      if (current.clipX || current.clipY) {
        return Offset(current.scrollLeft, current.scrollTop);
      }
    }
    current = current.parent;
  }
  return null;
}

// Get the offset of the RenderPlaceholder of positioned element to its parent RenderBoxModel.
Offset _getPlaceholderToParentOffset(RenderPositionPlaceholder placeholder, RenderBoxModel parent) {
  if (!placeholder.attached) {
    return Offset.zero;
  }
  Offset positionHolderScrollOffset = _getRenderPositionHolderScrollOffset(placeholder, parent) ?? Offset.zero;
  Offset placeholderOffset = placeholder.localToGlobal(positionHolderScrollOffset, ancestor: parent);
  return placeholderOffset;
}

class CSSPositionedLayout {
  static RenderLayoutParentData getPositionParentData(RenderBoxModel renderBoxModel, RenderLayoutParentData parentData) {
    CSSPositionType positionType = renderBoxModel.renderStyle.position;
    parentData.isPositioned = positionType == CSSPositionType.absolute || positionType == CSSPositionType.fixed;
    return parentData;
  }

  static Offset? getRelativeOffset(RenderStyle renderStyle) {
      CSSLengthValue left = renderStyle.left;
      CSSLengthValue right = renderStyle.right;
      CSSLengthValue top = renderStyle.top;
      CSSLengthValue bottom = renderStyle.bottom;
      if (renderStyle.position == CSSPositionType.relative) {
        double? dx;
        double? dy;

        if (left.isNotAuto) {
          dx = renderStyle.left.computedValue;
        } else if (right.isNotAuto) {
          double _dx = renderStyle.right.computedValue;
          dx = -_dx;
        }

        if (top.isNotAuto) {
          dy = renderStyle.top.computedValue;
        } else if (bottom.isNotAuto) {
          double _dy = renderStyle.bottom.computedValue;
          dy = -_dy;
        }

        if (dx != null || dy != null) {
          return Offset(dx ?? 0, dy ?? 0);
        }
      }
      return null;
    }

  static void applyRelativeOffset(Offset? relativeOffset, RenderBox renderBox) {
    RenderLayoutParentData? boxParentData = renderBox.parentData as RenderLayoutParentData?;

    if (boxParentData != null) {
      Offset? styleOffset;
      // Text node does not have relative offset
      if (renderBox is RenderBoxModel) {
        styleOffset = getRelativeOffset(renderBox.renderStyle);
      }

      if (relativeOffset != null) {
        if (styleOffset != null) {
          boxParentData.offset = relativeOffset.translate(styleOffset.dx, styleOffset.dy);
        } else {
          boxParentData.offset = relativeOffset;
        }
      } else {
        boxParentData.offset = styleOffset!;
      }
    }
  }

  static bool isSticky(RenderBoxModel child) {
    final renderStyle = child.renderStyle;
    return renderStyle.position == CSSPositionType.sticky &&
        (renderStyle.top.isNotAuto ||
        renderStyle.left.isNotAuto ||
        renderStyle.bottom.isNotAuto ||
        renderStyle.right.isNotAuto);
  }

  /// Set horizontal offset of sticky element
  static bool _applyStickyChildHorizontalOffset(
    RenderBoxModel scrollContainer,
    RenderBoxModel child,
    Offset childOriginalOffset,
    Offset childToScrollContainerOffset,
  ) {
    bool isHorizontalFixed = false;
    double offsetX = childOriginalOffset.dx;
    double childWidth = child.boxSize!.width;
    double scrollContainerWidth = scrollContainer.boxSize!.width;
    // Dynamic offset to scroll container
    double offsetLeftToScrollContainer = childToScrollContainerOffset.dx - scrollContainer.scrollLeft;
    double offsetRightToScrollContainer = scrollContainerWidth - childWidth - offsetLeftToScrollContainer;
    RenderStyle childRenderStyle = child.renderStyle;
    RenderStyle? scrollContainerRenderStyle = scrollContainer.renderStyle;

    if (childRenderStyle.left.isNotAuto) {
      // Sticky offset to scroll container must include padding and border
      double stickyLeft = childRenderStyle.left.computedValue +
        scrollContainerRenderStyle.paddingLeft.computedValue +
        scrollContainerRenderStyle.effectiveBorderLeftWidth.computedValue;
      isHorizontalFixed = offsetLeftToScrollContainer < stickyLeft;
      if (isHorizontalFixed) {
        offsetX += stickyLeft - offsetLeftToScrollContainer;
        // Sticky child can not exceed the left boundary of its parent container
        RenderBoxModel parentContainer = child.parent as RenderBoxModel;
        double maxOffsetX = parentContainer.boxSize!.width - childWidth;
        if (offsetX > maxOffsetX) {
          offsetX = maxOffsetX;
        }
      }
    } else if (childRenderStyle.left.isNotAuto) {
      // Sticky offset to scroll container must include padding and border
      double stickyRight = childRenderStyle.right.computedValue +
        scrollContainerRenderStyle.paddingRight.computedValue +
        scrollContainerRenderStyle.effectiveBorderRightWidth.computedValue;
      isHorizontalFixed = offsetRightToScrollContainer < stickyRight;
      if (isHorizontalFixed) {
        offsetX += offsetRightToScrollContainer - stickyRight;
        // Sticky element can not exceed the right boundary of its parent container
        double minOffsetX = 0;
        if (offsetX < minOffsetX) {
          offsetX = minOffsetX;
        }
      }
    }

    RenderLayoutParentData boxParentData = child.parentData as RenderLayoutParentData;
    boxParentData.offset = Offset(
      offsetX,
      boxParentData.offset.dy,
    );
    return isHorizontalFixed;
  }

  /// Set vertical offset of sticky element
  static bool _applyStickyChildVerticalOffset(
    RenderBoxModel scrollContainer,
    RenderBoxModel child,
    Offset childOriginalOffset,
    Offset childToScrollContainerOffset,
  ) {
    bool isVerticalFixed = false;
    double offsetY = childOriginalOffset.dy;
    double childHeight = child.boxSize!.height;
    double scrollContainerHeight = scrollContainer.boxSize!.height;
    // Dynamic offset to scroll container
    double offsetTopToScrollContainer = childToScrollContainerOffset.dy;
    double offsetBottomToScrollContainer = scrollContainerHeight - childHeight - offsetTopToScrollContainer;
    RenderStyle childRenderStyle = child.renderStyle;
    RenderStyle? scrollContainerRenderStyle = scrollContainer.renderStyle;

    if (childRenderStyle.top.isNotAuto) {
      // Sticky offset to scroll container must include padding and border
      double stickyTop = childRenderStyle.top.computedValue +
        scrollContainerRenderStyle.paddingTop.computedValue +
        scrollContainerRenderStyle.effectiveBorderTopWidth.computedValue;
      isVerticalFixed = offsetTopToScrollContainer < stickyTop;
      if (isVerticalFixed) {
        offsetY += stickyTop - offsetTopToScrollContainer;
        // Sticky child can not exceed the bottom boundary of its parent container
        RenderBoxModel parentContainer = child.parent as RenderBoxModel;
        double maxOffsetY = parentContainer.boxSize!.height - childHeight;
        if (offsetY > maxOffsetY) {
          offsetY = maxOffsetY;
        }
      }
    } else if (childRenderStyle.bottom.isNotAuto) {
      // Sticky offset to scroll container must include padding and border
      double stickyBottom = childRenderStyle.bottom.computedValue +
        scrollContainerRenderStyle.paddingBottom.computedValue +
        scrollContainerRenderStyle.effectiveBorderBottomWidth.computedValue;
      isVerticalFixed = offsetBottomToScrollContainer < stickyBottom;
      if (isVerticalFixed) {
        offsetY += offsetBottomToScrollContainer - stickyBottom;
        // Sticky child can not exceed the upper boundary of its parent container
        double minOffsetY = 0;
        if (offsetY < minOffsetY) {
          offsetY = minOffsetY;
        }
      }
    }

    RenderLayoutParentData boxParentData = child.parentData as RenderLayoutParentData;
    boxParentData.offset = Offset(
      boxParentData.offset.dx,
      offsetY,
    );
    return isVerticalFixed;
  }

  /// Set sticky child offset according to scroll offset and direction,
  /// when axisDirection param is null compute the both axis direction.
  /// Sticky positioning is similar to relative positioning except
  /// the offsets are automatically calculated in reference to the nearest scrollport.
  /// https://www.w3.org/TR/css-position-3/#stickypos-insets
  static void applyStickyChildOffset(RenderBoxModel scrollContainer, RenderBoxModel child) {
    RenderPositionPlaceholder childRenderPositionHolder = child.renderPositionPlaceholder!;
    RenderLayoutParentData childPlaceHolderParentData = childRenderPositionHolder.parentData as RenderLayoutParentData;
    // Original offset of sticky child in relative status
    Offset childOriginalOffset = childPlaceHolderParentData.offset;

    // Offset of sticky child to scroll container
    Offset childToScrollContainerOffset =
      childRenderPositionHolder.localToGlobal(Offset.zero, ancestor: scrollContainer);

    bool isVerticalFixed = false;
    bool isHorizontalFixed = false;
    RenderStyle childRenderStyle = child.renderStyle;

    if (childRenderStyle.left.isNotAuto || childRenderStyle.right.isNotAuto) {
      isHorizontalFixed = _applyStickyChildHorizontalOffset(
        scrollContainer, child, childOriginalOffset, childToScrollContainerOffset
      );
    }
    if (childRenderStyle.top.isNotAuto || childRenderStyle.bottom.isNotAuto) {
      isVerticalFixed = _applyStickyChildVerticalOffset(
        scrollContainer, child, childOriginalOffset, childToScrollContainerOffset
      );
    }

    if (isVerticalFixed || isHorizontalFixed) {
      // Change sticky status to fixed
      child.stickyStatus = StickyPositionType.fixed;
      child.markNeedsPaint();
    } else {
      // Change sticky status to relative
      if (child.stickyStatus == StickyPositionType.fixed) {
        child.stickyStatus = StickyPositionType.relative;
        // Reset child offset to its original offset
        child.markNeedsPaint();
      }
    }
  }

  static void layoutPositionedChild(
    RenderBoxModel parent,
    RenderBoxModel child,
    {bool needsRelayout = false}
  ) {
    BoxConstraints childConstraints = child.getConstraints();

    // Whether child need to layout
    bool isChildNeedsLayout = true;
    if (child.hasSize &&
      !needsRelayout &&
      (childConstraints == child.constraints) &&
      (!child.needsLayout)
    ) {
      isChildNeedsLayout = false;
    }

    if (isChildNeedsLayout) {
      late DateTime childLayoutStartTime;
      if (kProfileMode) {
        childLayoutStartTime = DateTime.now();
      }

      // Should create relayoutBoundary for positioned child.
      child.layout(childConstraints, parentUsesSize: false);

      if (kProfileMode) {
        DateTime childLayoutEndTime = DateTime.now();
        parent.childLayoutDuration += (childLayoutEndTime.microsecondsSinceEpoch - childLayoutStartTime.microsecondsSinceEpoch);
      }
    }
  }

  // Position of positioned element involves inset, size , margin and its containing block size.
  // https://www.w3.org/TR/css-position-3/#abs-non-replaced-width
  static void applyPositionedChildOffset(
    RenderBoxModel parent,
    RenderBoxModel child,
  ) {
    final RenderLayoutParentData childParentData = child.parentData as RenderLayoutParentData;
    Size size = child.boxSize!;
    Size parentSize = parent.boxSize!;
    RenderStyle parentRenderStyle = parent.renderStyle;

    // Calculate offset to overflow container box first, then subtract border and padding
    // to get the offset to scrolling content box.
    if (parent.isScrollingContentBox) {
      RenderLayoutBox overflowContainerBox = parent.parent as RenderLayoutBox;
      parentRenderStyle = overflowContainerBox.renderStyle;
      parentSize = Size(
        parentSize.width
          - parentRenderStyle.effectiveBorderLeftWidth.computedValue
          - parentRenderStyle.effectiveBorderRightWidth.computedValue,
        parentSize.height
          - parentRenderStyle.effectiveBorderTopWidth.computedValue
          - parentRenderStyle.effectiveBorderBottomWidth.computedValue,
      );
    }

    CSSLengthValue parentBorderLeftWidth = parentRenderStyle.effectiveBorderLeftWidth;
    CSSLengthValue parentBorderRightWidth = parentRenderStyle.effectiveBorderRightWidth;
    CSSLengthValue parentBorderTopWidth = parentRenderStyle.effectiveBorderTopWidth;
    CSSLengthValue parentBorderBottomWidth = parentRenderStyle.effectiveBorderBottomWidth;

    // The containing block of not an inline box is formed by the padding edge of the ancestor.
    // Thus the final offset of child need to add the border of parent.
    // https://www.w3.org/TR/css-position-3/#def-cb
    Size containingBlockSize = Size(
      parentSize.width
        - parentBorderLeftWidth.computedValue
        - parentBorderRightWidth.computedValue,
      parentSize.height
        - parentBorderTopWidth.computedValue
        - parentBorderBottomWidth.computedValue
    );

    RenderStyle childRenderStyle = child.renderStyle;
    CSSLengthValue left = childRenderStyle.left;
    CSSLengthValue right = childRenderStyle.right;
    CSSLengthValue top = childRenderStyle.top;
    CSSLengthValue bottom = childRenderStyle.bottom;
    CSSLengthValue marginLeft = childRenderStyle.marginLeft;
    CSSLengthValue marginRight = childRenderStyle.marginRight;
    CSSLengthValue marginTop = childRenderStyle.marginTop;
    CSSLengthValue marginBottom = childRenderStyle.marginBottom;

    // ScrollTop and scrollLeft will be added to offset of renderBox in the paint stage
    // for positioned fixed element.
    if (childRenderStyle.position == CSSPositionType.fixed) {
      Element rootElement = parentRenderStyle.target;
      child.scrollingOffsetX = rootElement.scrollLeft;
      child.scrollingOffsetY = rootElement.scrollTop;
    }

    // The static position of positioned element is its offset when its position property had been static
    // which equals to the position of its placeholder renderBox.
    // https://www.w3.org/TR/CSS2/visudet.html#static-position
    Offset staticPositionOffset = _getPlaceholderToParentOffset(child.renderPositionPlaceholder!, parent);

    double x = _computePositionedOffset(
      parentBorderBeforeWidth: parentBorderLeftWidth,
      containingBlockLength: containingBlockSize.width,
      length: size.width,
      staticPosition: staticPositionOffset.dx,
      insetBefore: left,
      insetAfter: right,
      marginBefore: marginLeft,
      marginAfter: marginRight,
    );

    double y = _computePositionedOffset(
      parentBorderBeforeWidth: parentBorderTopWidth,
      containingBlockLength: containingBlockSize.height,
      length: size.height,
      staticPosition: staticPositionOffset.dy,
      insetBefore: top,
      insetAfter: bottom,
      marginBefore: marginTop,
      marginAfter: marginBottom,
    );

    // Convert position relative to scrolling content box.
    // Scrolling content box positions relative to the content edge of its parent.
    if (parent.isScrollingContentBox) {
      x -= parentRenderStyle.effectiveBorderLeftWidth.computedValue + parentRenderStyle.paddingLeft.computedValue;
      y -= parentRenderStyle.effectiveBorderTopWidth.computedValue + parentRenderStyle.paddingTop.computedValue;
    }

    childParentData.offset = Offset(x, y);
  }

  // Compute the offset of positioned element in one axis.
  static double _computePositionedOffset({
    required CSSLengthValue parentBorderBeforeWidth,
    required double containingBlockLength,
    required double length,
    required double staticPosition,
    required CSSLengthValue insetBefore,
    required CSSLengthValue insetAfter,
    required CSSLengthValue marginBefore,
    required CSSLengthValue marginAfter,
  }) {

    // Offset of positioned element in one axis.
    double offset;

    // Take horizontal axis for example.
    // left + margin-left + width + margin-right + right = width of containing block
    // Refer to the table of `Summary of rules for dir=ltr in horizontal writing modes` in following spec.
    // https://www.w3.org/TR/css-position-3/#abs-non-replaced-width
    if (insetBefore.isAuto && insetAfter.isAuto) {
      // left → static pos
      offset = staticPosition;
    } else if (insetBefore.isNotAuto && insetAfter.isNotAuto) {
      double freeSpace = containingBlockLength - length
        - insetBefore.computedValue - insetAfter.computedValue;

      double marginBeforeValue;

      if (marginBefore.isAuto && marginAfter.isAuto) {
        if (freeSpace < 0) {
          // margin-left → '0', solve for margin-right
          marginBeforeValue = 0;
        } else {
          // margins split positive free space
          marginBeforeValue = freeSpace / 2;
        }
      } else if (marginBefore.isAuto && marginAfter.isNotAuto) {
        // auto margin left → free space
        marginBeforeValue = freeSpace - marginAfter.computedValue;
      } else {
        marginBeforeValue = marginBefore.computedValue;
      }

      offset = parentBorderBeforeWidth.computedValue + insetBefore.computedValue + marginBeforeValue;
    } else if (insetBefore.isAuto && insetAfter.isNotAuto) {
      // auto margins → zero, left → solve
      double leftValue = containingBlockLength - length - insetAfter.computedValue
        - marginBefore.computedValue - marginAfter.computedValue;

      offset = parentBorderBeforeWidth.computedValue + leftValue + marginBefore.computedValue;
    } else {
      // left → as specified
      offset = parentBorderBeforeWidth.computedValue + insetBefore.computedValue + marginBefore.computedValue;
    }

    return offset;
  }
}
