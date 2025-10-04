══╡ EXCEPTION CAUGHT BY RENDERING LIBRARY ╞═════════════════════════════════════════════════════════
The following assertion was thrown during layout:
A RenderFlex overflowed by 1.8 pixels on the right.

The relevant error-causing widget was:
  Row Row:file:///C:/HabitV8/lib/ui/screens/onboarding_screen.dart:503:20

To inspect this widget in Flutter DevTools, visit:
http://127.0.0.1:9102/#/inspector?uri=http%3A%2F%2F127.0.0.1%3A50728%2FZIpdGdVP1sA%3D%2F&inspectorRef=inspector-0

The overflowing RenderFlex has an orientation of Axis.horizontal.
The edge of the RenderFlex that is overflowing has been marked in the rendering with a yellow and
black striped pattern. This is usually caused by the contents being too big for the RenderFlex.
Consider applying a flex factor (e.g. using an Expanded widget) to force the children of the
RenderFlex to fit within the available space instead of being sized to their natural size.
This is considered an error condition because it indicates that there is content that cannot be
seen. If the content is legitimately bigger than the available space, consider clipping it with a
ClipRect widget before putting it in the flex, or using a scrollable container rather than a Flex,
like a ListView.
The specific RenderFlex in question is: RenderFlex#15f1c relayoutBoundary=up5 OVERFLOWING:
  creator: Row ← Padding ← DecoratedBox ← Container ← Column ← Padding ← _SingleChildViewport ←
    IgnorePointer-[GlobalKey#7d800] ← Semantics ← Listener ← _GestureSemantics ←
    RawGestureDetector-[LabeledGlobalKey<RawGestureDetectorState>#d1c2a] ← ⋯
  parentData: offset=Offset(13.0, 13.0) (can use size)
  constraints: BoxConstraints(0.0<=w<=358.0, 0.0<=h<=Infinity)
  size: Size(358.0, 20.0)
  direction: horizontal
  mainAxisAlignment: start
  mainAxisSize: min
  crossAxisAlignment: center
  textDirection: ltr
  verticalDirection: down
  spacing: 0.0
◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤