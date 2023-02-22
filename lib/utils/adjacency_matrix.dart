import 'package:graph_drawer/utils/utils.dart';

List<List<int>> adjacencyMatrix(List<String> nodesNames, List<EdgeConnection> edgesConnections) {
  List<List<int>> adjacencyMatrix = List.generate(nodesNames.length + 1, (index) => List.filled(nodesNames.length + 1, 0));
  Map<String, int> nodeIndices = {};
  List<int> rowSums = List.filled(nodesNames.length, 0);
  List<int> colSums = List.filled(nodesNames.length, 0);

  for (int i = 0; i < nodesNames.length; i++) {
    nodeIndices[nodesNames[i]] = i;
  }
  if (edgesConnections.isNotEmpty) {
    for (var obj in edgesConnections) {
      int sourceIndex = nodeIndices[obj.source]!;
      int targetIndex = nodeIndices[obj.target]!;
      adjacencyMatrix[sourceIndex][targetIndex] = obj.cost;
      rowSums[sourceIndex] += obj.cost;
      colSums[targetIndex] += obj.cost;
    }
  }
  for (int i = 0; i < nodesNames.length; i++) {
    adjacencyMatrix[i][nodesNames.length] = rowSums[i];
    adjacencyMatrix[nodesNames.length][i] = colSums[i];
  }

  // for (int i = 0; i < adjacencyMatrix.length; i++) {
  //   print(adjacencyMatrix[i]);
  // }
  return adjacencyMatrix;
}
