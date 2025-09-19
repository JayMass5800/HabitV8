══╡ EXCEPTION CAUGHT BY RENDERING LIBRARY ╞═════════════════════════════════════════════════════════
The following assertion was thrown during layout:
A RenderFlex overflowed by 75 pixels on the bottom.

The relevant error-causing widget was:
  Column Column:file:///C:/HabitV8/lib/ui/screens/onboarding_screen.dart:163:14

To inspect this widget in Flutter DevTools, visit:
http://127.0.0.1:9101/#/inspector?uri=http%3A%2F%2F127.0.0.1%3A50603%2FCy-e5vSquvY%3D%2F&inspectorRef=inspector-0

The overflowing RenderFlex has an orientation of Axis.vertical.
The edge of the RenderFlex that is overflowing has been marked in the rendering with a yellow and
black striped pattern. This is usually caused by the contents being too big for the RenderFlex.
Consider applying a flex factor (e.g. using an Expanded widget) to force the children of the
RenderFlex to fit within the available space instead of being sized to their natural size.
This is considered an error condition because it indicates that there is content that cannot be
seen. If the content is legitimately bigger than the available space, consider clipping it with a
ClipRect widget before putting it in the flex, or using a scrollable container rather than a Flex,
like a ListView.
The specific RenderFlex in question is: RenderFlex#5a52d OVERFLOWING:
  creator: Column ← Padding ← RepaintBoundary ← IndexedSemantics ← _SelectionKeepAlive ←
    NotificationListener<KeepAliveNotification> ← KeepAlive ← AutomaticKeepAlive ← KeyedSubtree ←
    _SliverFillViewportRenderObjectWidget ← _SliverFractionalPadding ← SliverFillViewport ← ⋯
  parentData: offset=Offset(32.0, 32.0) (can use size)
  constraints: BoxConstraints(w=384.0, h=579.1)
  size: Size(384.0, 579.1)
  direction: vertical
  mainAxisAlignment: center
  mainAxisSize: max
  crossAxisAlignment: center
  verticalDirection: down
  spacing: 0.0
◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤
════════════════════════════════════════════════════════════════════════════════════════════════════