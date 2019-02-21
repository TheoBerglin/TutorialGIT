classdef Graph < handle & matlab.mixin.Copyable
    % Graph < handle & matlab.mixin.Copyable (Abstract) : Creates and implements graph
    %   Graph represents graph and a set of measures that can be calculated
    %   on an instance of a graph.
    %   Instances of this class cannot be created. Use one of the subclasses
    %   (e.g., GraphBD, GraphBU, GraphWD, GraphWU).
    %
    % Graph properties (Constant):
    %   A measure denoted by MEAS can have 4 properties. The properties
    %   addmissible to any measure are defined as follows:
    %   MEAS        -   order number for the measure
    %   MEAS_NAME   -   name of the measure
    %   MEAS_NODAL  -   logical expression of nodality of the measure
    %   MEAS_TXT    -   description of the measure
    %
    %   Example: The measure DEGREE is a nodal measure of the number of connections
    %   of each node in a graph. It has the following properties:
    %       DEGREE = 1;
    %       DEGREE_NAME = 'degree';
    %       DEGREE_NODAL = true;
    %       DEGREE_TXT = 'The degree of a node is the number of edges connected to the node.
    %                      Connection weights are ignored in calculations.'
    %
    % The measures that can be calculated are the following:
    %   DEGREE              -   degree of a node
    %   DEGREEAV            -   average degree of a graph
    %   IN_DEGREE           -   in-degree of a node
    %   IN_DEGREEAV         -   average in-degree of a graph
    %   OUT_DEGREE          -   out-degree of a node
    %   OUT_DEGREEAV        -   average out-degree of a graph
    %   STRENGTH            -   strength of a node
    %   STRENGTHAV          -   average strength of a graph
    %   IN_STRENGTH         -   in-strength of a node
    %   IN_STRENGTHAV       -   average in-strength of a graph
    %   OUT_STRENGTH        -   out-strength of a node
    %   OUT_STRENGTHAV      -   average out-strength of a graph
    %   TRIANGLES           -   number of triangles around a node
    %   CPL                 -   characteristic path length of a graph
    %   PL                  -   path length of a node
    %   IN_CPL              -   characteristic in-path length of a graph
    %   IN_PL               -   in-path length of a node
    %   OUT_CPL             -   characteristic out-path length of a graph
    %   OUT_PL              -   out-path length of a node
    %   GEFF                -   global efficiency of a graph
    %   GEFFNODE            -   global efficiency of a node
    %   IN_GEFF             -   in-global efficiency of a graph
    %   IN_GEFFNODE         -   in-global efficiency of a node
    %   OUT_GEFF            -   out-global efficiency of a graph
    %   OUT_GEFFNODE        -   out-global efficiency of a node
    %   LEFF                -   local efficiency of a graph
    %   LEFFNODE            -   local efficiency of a node
    %   IN_LEFF             -   in-local efficiency of a graph
    %   IN_LEFFNODE         -   in-local efficiency of a node
    %   OUT_LEFF            -   out-local efficiency of a graph
    %   OUT_LEFFNODE        -   out-local efficiency of a node
    %   CLUSTER             -   clustering coefficient of a graph
    %   CLUSTERNODE         -   clustering coefficient around a node
    %   BETWEENNESS         -   betweenness centrality of a node
    %   CLOSENESS           -   closeness centrality of a node
    %   IN_CLOSENESS        -   in-closeness centrality of a node
    %   OUT_CLOSENESS       -   out-closeness centrality of a node
    %   ZSCORE              -   within module degree z-score of a node
    %   IN_ZSCORE           -   within module degree in-z-score of a node
    %   OUT_ZSCORE          -   within module degree out-z-score of a node
    %   PARTICIPATION       -   participation
    %   TRANSITIVITY        -   transitivity of a graph
    %   ECCENTRICITY        -   eccentricity of a node
    %   ECCENTRICITYAV      -   average eccentricity of a graph
    %   IN_ECCENTRICITY     -   in-eccentricity of a node
    %   IN_ECCENTRICITYAV   -   average in-eccentricity of a graph
    %   OUT_ECCENTRICITY    -   out-eccentricity of a node
    %   OUT_ECCENTRICITYAV  -   average out-eccentricity of a graph
    %   RADIUS              -   minimum eccentricity of a graph
    %   DIAMETER            -   maximum eccentricity of a graph
    %   CPL_WSG             -   characteristic path length of a graph (within connected subgraphs)
    %   ASSORTATIVITY       -   assortativity
    %   SW                  -   small worldness
    %   SW_WSG              -   small worldness (within connected subgraphs)
    %
    %   NAME     -   array of names of the measures
    %   NODAL    -   array of logical expressions of nodality of the measures
    %   TXT      -   array of descriptions of the measure
    %
    % Graph properties (GetAccess = public, SetAccess = protected):
    %   A        -   connection matrix
    %   P        -   coefficient p-values
    %   S        -   default community structure
    %   TYPE     -   graph type
    %
    % Graph properties (Access = protected):
    %   N        -   number of nodes
    %   D        -   matrix of the shortest path lengths
    %   deg      -   degree
    %   indeg    -   in-degree
    %   outdeg   -   out-degree
    %   str      -   strength
    %   instr    -   in-strength
    %   outstr   -   out-strength
    %   ecc      -   eccentricity
    %   eccin    -   in-eccentricity
    %   eccout   -   out-eccentricity
    %   t        -   triangles
    %   c        -   path length
    %   cin      -   in-path length
    %   cout     -   out-path length
    %   ge       -   global efficiency
    %   gein     -   in-global efficiency
    %   geout    -   out-global efficiency
    %   le       -   local efficiency
    %   lenode   -   local efficiency of a node
    %   cl       -   clustering coefficient
    %   clnode   -   clustering coefficient of a node
    %   b        -   betweenness (non-normalized)
    %   tr       -   transitivity
    %   clo      -   closeness
    %   cloin    -   in-closeness
    %   cloout   -   out-closeness
    %   Ci       -   structure
    %   m        -   modularity
    %   z        -   z-score
    %   zin      -   in-z-score
    %   zout     -   out-z-score
    %   p        -   participation
    %   a        -   assortativity
    %   sw       -   small-worldness
    %   sw_wsg   -   small-worldness
    %
    % Graph methods (Access = protected):
    %   Graph                               -   constructor
    %   reset_structure_related_measures    -   resets z-score and participation
    %   copyElement                         -   copy community structure
    %
    % Graph methods (Abstract):
    %   weighted     -   weighted graph
    %   binary       -   binary graph
    %   directed	 -   direced graph
    %   undirected   -   undirected graph
    %   distance     -   distance between nodes (shortest path length)
    %   measure      -   calculates given measure
    %   randomize    -   randomize graph while preserving degree distribution
    %
    % Graph methods :
    %   get_type            -   returns the type of the graph
    %   subgraph            -   creates subgraph from given nodes
    %   nodeattack          -   removes given nodes from a graph
    %   edgeattack          -   removes given edges from a graph
    %   nodenumber          -   number of nodes in a graph
    %   radius              -   radius of a graph
    %   diameter            -   diameter of a graph
    %   eccentricity        -   eccentricity of nodes
    %   pl                  -   path length of nodes
    %   closeness           -   closeness centrality of nodes
    %   structure           -   community structures of a graph
    %   zscore              -   within module degree z-score
    %   participation       -   participation coefficient of nodes
    %   smallworldness       -   small-wordness of the graph
    %
    % Graph methods (Static):
    %   removediagonal      -   replaces matrix diagonal with given value
    %   symmetrize          -   symmetrizes a matrix
    %   histogram           -   histogram of a matrix
    %   binarize            -   binarizes a matrix
    %   plotw               -   plots a weighted matrix
    %   plotb               -   plots a binary matrix
    %   hist                -   plots the histogram and density of a matrix
    %   isnodal             -   checks if measure is nodal
    %   isglobal            -   checks if measure is global
    %   is_directed         -   checks if the graph type is directed
    %   is_undirected       -   checks if the graph type is undirected
    %   is_binary           -   checks if the graph type is binary
    %   is_weighted         -   checks if the graph type is weighted
    %   is_positive         -   checks if the graph type has only non-negative weights
    %   is_negative         -   checks if the graph type has also negative weights
    %
    % Graph methods (Static, Abstract):
    %   measurelist         -   list of measures valid for a graph
    %   measurenumber       -   number of measures valid for a graph
    %
    % See also GraphBD, GraphBU, GraphWD, GraphWU, Structure, handle, matlab.mixin.Copyable.
    
    % Author: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
    % Date: 2016/01/01
    
    properties (Constant)
        % Graph types
        BD = 1; % Binary Directed
        BU = 2; % Binary Undirected
        WD = 3; % Weighted Directed
        WU = 4; % Weighted Undirected
        WDN = 5; % Weighted Directed with Negative weights
        WUN = 6; % Weighted Undirected with Negative weights
        
        % community structure
        CS_NAME = 'community structure';
        CS_DESCRIPTION = 'The optimal community structure is a structure with maximum number of edges connecting nodes within communities compared to the edges connecting nodes between communities.'
        CS_LAST_PARAMS = '';
        
        % measures
        DEFAULT_MEASURE_VALUE = [];
        
        DEGREE = 1;
        DEGREE_NAME = 'degree';
        DEGREE_NODAL = true;
        DEGREE_DESCRIPTION = 'The degree of a node is the number of edges connected to the node. Connection weights are ignored in calculations.';
        DEGREE_FUNCTION = 'degree';
        DEGREE_AVERAGE = false;
        DEGREE_STRUCTURAL = false;
        
        DEGREEAV = 2;
        DEGREEAV_NAME = 'av. degree';
        DEGREEAV_NODAL = false;
        DEGREEAV_DESCRIPTION = 'The average degree of a graph is the average node degree. The node degree is the number of edges connected to the node. Connection weights are ignored in calculations.';
        DEGREEAV_FUNCTION = 'degree';
        DEGREEAV_AVERAGE = true;
        DEGREEAV_STRUCTURAL = false;
        
        IN_DEGREE = 3;
        IN_DEGREE_NAME = 'in-degree';
        IN_DEGREE_NODAL = true;
        IN_DEGREE_DESCRIPTION = 'In directed graphs, the in-degree of a node is the number of inward edges. Connection weights are ignored in calculations.';
        IN_DEGREE_FUNCTION = 'degree_in';
        IN_DEGREE_AVERAGE = false;
        IN_DEGREE_STRUCTURAL = false;
        
        IN_DEGREEAV = 4;
        IN_DEGREEAV_NAME = 'av. in-degree';
        IN_DEGREEAV_NODAL = true;
        IN_DEGREEAV_DESCRIPTION = 'In directed graphs, the average in-degree is the average node in-degree. The node in-degree of a node is the number of inward edges. Connection weights are ignored in calculations.';
        IN_DEGREEAV_FUNCTION = 'degree_in';
        IN_DEGREEAV_AVERAGE = true;
        IN_DEGREEAV_STRUCTURAL = false;
        
        OUT_DEGREE = 5;
        OUT_DEGREE_NAME = 'out-degree';
        OUT_DEGREE_NODAL = true;
        OUT_DEGREE_DESCRIPTION = 'In directed graphs, the out-degree of a node is the number of outward edges. Connection weights are ignored in calculations.';
        OUT_DEGREE_FUNCTION = 'degree_out';
        OUT_DEGREE_AVERAGE = false;
        OUT_DEGREE_STRUCTURAL = false;
        
        OUT_DEGREEAV = 6;
        OUT_DEGREEAV_NAME = 'av. out-degree';
        OUT_DEGREEAV_NODAL = true;
        OUT_DEGREEAV_DESCRIPTION = 'In directed graphs, the average out-degree is the average node out-degree. The node out-degree of a node is the number of outward edges. Connection weights are ignored in calculations.';
        OUT_DEGREEAV_FUNCTION = 'degree_out';
        OUT_DEGREEAV_AVERAGE = true;
        OUT_DEGREEAV_STRUCTURAL = false;
        
        STRENGTH = 7;
        STRENGTH_NAME = 'strength';
        STRENGTH_NODAL = true;
        STRENGTH_DESCRIPTION = 'The strength of a node is the sum of the weights of the edges connected to the node.';
        STRENGTH_FUNCTION = 'strength';
        STRENGTH_AVERAGE = false;
        STRENGTH_STRUCTURAL = false;
        
        STRENGTHAV = 8;
        STRENGTHAV_NAME = 'av. strength';
        STRENGTHAV_NODAL = false;
        STRENGTHAV_DESCRIPTION = 'The average strength of a graph is the average node strength. The node strength is the sum of the weights of the edges connected to the node.';
        STRENGTHAV_FUNCTION = 'strength';
        STRENGTHAV_AVERAGE = true;
        STRENGTHAV_STRUCTURAL = false;
        
        IN_STRENGTH = 9;
        IN_STRENGTH_NAME = 'in-strength';
        IN_STRENGTH_NODAL = true;
        IN_STRENGTH_DESCRIPTION = 'In directed graphs, the in-strength of a node is the sum of inward edge weights. Connection weights are ignored in calculations.';
        IN_STRENGTH_FUNCTION = 'strength_in';
        IN_STRENGTH_AVERAGE = false;
        IN_STRENGTH_STRUCTURAL = false;
        
        IN_STRENGTHAV = 10;
        IN_STRENGTHAV_NAME = 'av. in-strength';
        IN_STRENGTHAV_NODAL = true;
        IN_STRENGTHAV_DESCRIPTION = 'In directed graphs, the average in-strength is the average node in-strength. The node in-strength of a node is the sum of inward edge weights.';
        IN_STRENGTHAV_FUNCTION = 'strength_in';
        IN_STRENGTHAV_AVERAGE = true;
        IN_STRENGTHAV_STRUCTURAL = false;
        
        OUT_STRENGTH = 11;
        OUT_STRENGTH_NAME = 'out-strength';
        OUT_STRENGTH_NODAL = true;
        OUT_STRENGTH_DESCRIPTION = 'In directed graphs, the out-strength of a node is the sum of outward edge weights.';
        OUT_STRENGTH_FUNCTION = 'strength_out';
        OUT_STRENGTH_AVERAGE = false;
        OUT_STRENGTH_STRUCTURAL = false;
        
        OUT_STRENGTHAV = 12;
        OUT_STRENGTHAV_NAME = 'av. out-strength';
        OUT_STRENGTHAV_NODAL = true;
        OUT_STRENGTHAV_DESCRIPTION = 'In directed graphs, the average out-strength is the average node out-strength. The node out-strength of a node is the sum of outward edge weights.';
        OUT_STRENGTHAV_FUNCTION = 'strength_out';
        OUT_STRENGTHAV_AVERAGE = true;
        OUT_STRENGTHAV_STRUCTURAL = false;
        
        TRIANGLES = 13;
        TRIANGLES_NAME = 'triangles';
        TRIANGLES_NODAL = true;
        TRIANGLES_DESCRIPTION = 'The number of triangles around a node is the numbers of couples of node neighbors that are connected.';
        TRIANGLES_FUNCTION = 'triangles';
        TRIANGLES_AVERAGE = false;
        TRIANGLES_STRUCTURAL = false;
        
        CPL = 14;
        CPL_NAME = 'char. path length';
        CPL_NODAL = false;
        CPL_DESCRIPTION = 'The characteristic path length of a graph is the average shortest path length in the graph. It is the average of the path length of all nodes in the graph.';
        CPL_FUNCTION = 'pathlength';
        CPL_AVERAGE = true;
        CPL_STRUCTURAL = false;
        
        PL = 15;
        PL_NAME = 'path length';
        PL_NODAL = true;
        PL_DESCRIPTION = 'For undirected graphs, the path length of a node is the average path length from the note to all other nodes. For directed graphs, it is the sum of the in-path length and of the out-path length.';
        PL_FUNCTION = 'pathlength';
        PL_AVERAGE = false;
        PL_STRUCTURAL = false;
        
        IN_CPL = 16;
        IN_CPL_NAME = 'char. path length (in)';
        IN_CPL_NODAL = false;
        IN_CPL_DESCRIPTION = 'The characteristic in-path length of a graph is the average of the in-path length of all nodes in the graph.';
        IN_CPL_FUNCTION = 'pathlength_in';
        IN_CPL_AVERAGE = true;
        IN_CPL_STRUCTURAL = false;
        
        IN_PL = 17;
        IN_PL_NAME = 'path length (in)';
        IN_PL_NODAL = true;
        IN_PL_DESCRIPTION = 'The in-path length of a node is the average path length from the node itself to all other nodes.';
        IN_PL_FUNCTION = 'pathlength_in';
        IN_PL_AVERAGE = false;
        IN_PL_STRUCTURAL = false;
        
        OUT_CPL = 18;
        OUT_CPL_NAME = 'char. path length (out)';
        OUT_CPL_NODAL = false;
        OUT_CPL_DESCRIPTION = 'The characteristic out-path length of a graph is the average of the out-path length of all nodes in the graph.';
        OUT_CPL_FUNCTION = 'pathlength_out';
        OUT_CPL_AVERAGE = true;
        OUT_CPL_STRUCTURAL = false;
        
        OUT_PL = 19;
        OUT_PL_NAME = 'path length (out)';
        OUT_PL_NODAL = true;
        OUT_PL_DESCRIPTION = 'The out-path length of a node is the average path length from all other nodes to the node itself.';
        OUT_PL_FUNCTION = 'pathlength_out';
        OUT_PL_AVERAGE = false;
        OUT_PL_STRUCTURAL = false;
        
        GEFF = 20;
        GEFF_NAME = 'global efficiency';
        GEFF_NODAL = false;
        GEFF_DESCRIPTION = 'The global efficiency is the average inverse shortest path length in the graph. It is inversely related to the characteristic path length.';
        GEFF_FUNCTION = 'global_efficiency';
        GEFF_AVERAGE = false;
        GEFF_STRUCTURAL = false;
        
        GEFFNODE = 21;
        GEFFNODE_NAME = 'global efficiency nodes';
        GEFFNODE_NODAL = true;
        GEFFNODE_DESCRIPTION = 'The global efficiency of a node is the average inverse shortest path length of the node. It is inversely related to the path length of the node.';
        GEFFNODE_FUNCTION = 'global_efficiency';
        GEFFNODE_AVERAGE = false;
        GEFFNODE_STRUCTURAL = false;
        
        IN_GEFF = 22;
        IN_GEFF_NAME = 'global efficiency (in)';
        IN_GEFF_NODAL = false;
        IN_GEFF_DESCRIPTION = 'The characteristic in-global efficiency of a graph is the average of the in-global efficiency of all nodes in the graph.';
        IN_GEFF_FUNCTION = 'global_efficiency_in';
        IN_GEFF_AVERAGE = true;
        IN_GEFF_STRUCTURAL = false;
        
        IN_GEFFNODE = 23;
        IN_GEFFNODE_NAME = 'global efficiency nodes (in)';
        IN_GEFFNODE_NODAL = true;
        IN_GEFFNODE_DESCRIPTION = 'The in-global efficiency of a node is the average inverse path length from the node itself to all other nodes.';
        IN_GEFFNODE_FUNCTION = 'global_efficiency_in';
        IN_GEFFNODE_AVERAGE = false;
        IN_GEFFNODE_STRUCTURAL = false;
        
        OUT_GEFF = 24;
        OUT_GEFF_NAME = 'global efficiency (out)';
        OUT_GEFF_NODAL = false;
        OUT_GEFF_DESCRIPTION = 'The characteristic out-global efficiency of a graph is the average of the out-global efficiency of all nodes in the graph.';
        OUT_GEFF_FUNCTION = 'global_efficiency_out';
        OUT_GEFF_AVERAGE = true;
        OUT_GEFF_STRUCTURAL = false;
        
        OUT_GEFFNODE = 25;
        OUT_GEFFNODE_NAME = 'global efficiency nodes (out)';
        OUT_GEFFNODE_NODAL = true;
        OUT_GEFFNODE_DESCRIPTION = 'The out-global efficiency of a node is the average inverse path length from all other nodes to the node itself.';
        OUT_GEFFNODE_FUNCTION = 'global_efficiency_out';
        OUT_GEFFNODE_AVERAGE = false;
        OUT_GEFFNODE_STRUCTURAL = false;
        
        LEFF = 26;
        LEFF_NAME = 'local efficiency';
        LEFF_NODAL = false;
        LEFF_DESCRIPTION = 'The local efficiency of a graph is the average of the local efficiencies of its nodes. It is related to clustering coefficient.';
        LEFF_FUNCTION = 'local_efficiency_graph';
        LEFF_AVERAGE = false;
        LEFF_STRUCTURAL = false;
        
        LEFFNODE = 27;
        LEFFNODE_NAME = 'local efficiency nodes';
        LEFFNODE_NODAL = true;
        LEFFNODE_DESCRIPTION = 'The local efficiency of a node is the global efficiency of the node computed on the node''s neighborhood';
        LEFFNODE_FUNCTION = 'local_efficiency_nodal';
        LEFFNODE_AVERAGE = false;
        LEFFNODE_STRUCTURAL = false;
        
        IN_LEFF = 28;
        IN_LEFF_NAME = 'local efficiency (in)';
        IN_LEFF_NODAL = false;
        IN_LEFF_DESCRIPTION = 'The in-local efficiency of a graph is the average of the in-local efficiencies of its nodes.';
        IN_LEFF_FUNCTION = 'INPUT_FUNCTIONTION';
        IN_LEFF_AVERAGE = false;
        IN_LEFF_STRUCTURAL = false;
        
        IN_LEFFNODE = 29;
        IN_LEFFNODE_NAME = 'local efficiency nodes (in)';
        IN_LEFFNODE_NODAL = true;
        IN_LEFFNODE_DESCRIPTION = 'The in-local efficiency of a node is the in-global efficiency of the node computed on the node''s neighborhood';
        IN_LEFFNODE_FUNCTION = 'INPUT_FUNCTIONTION';
        IN_LEFFNODE_AVERAGE = false;
        IN_LEFFNODE_STRUCTURAL = false;
        
        OUT_LEFF = 30;
        OUT_LEFF_NAME = 'local efficiency (out)';
        OUT_LEFF_NODAL = false;
        OUT_LEFF_DESCRIPTION = 'The out-local efficiency of a graph is the average of the out-local efficiencies of its nodes.';
        OUT_LEFF_FUNCTION = 'INPUT_FUNCTIONTION';
        OUT_LEFF_AVERAGE = false;
        OUT_LEFF_STRUCTURAL = false;
        
        OUT_LEFFNODE = 31;
        OUT_LEFFNODE_NAME = 'local efficiency nodes (out)';
        OUT_LEFFNODE_NODAL = true;
        OUT_LEFFNODE_DESCRIPTION = 'The out-local efficiency of a node is the out-global efficiency of the node computed on the node''s neighborhood';
        OUT_LEFFNODE_FUNCTION = 'INPUT_FUNCTIONTION';
        OUT_LEFFNODE_AVERAGE = false;
        OUT_LEFFNODE_STRUCTURAL = false;
        
        CLUSTER = 32;
        CLUSTER_NAME = 'clustering';
        CLUSTER_NODAL = false;
        CLUSTER_DESCRIPTION = 'The clustering coefficient of a graph is the average of the clustering coefficients of its nodes.';
        CLUSTER_FUNCTION = 'clustering_global';
        CLUSTER_AVERAGE = false;
        CLUSTER_STRUCTURAL = false;
        
        CLUSTERNODE = 33;
        CLUSTERNODE_NAME = 'clustering nodes';
        CLUSTERNODE_NODAL = true;
        CLUSTERNODE_DESCRIPTION = 'The clustering coefficient is the fraction of triangles around a node. It is equivalent to the fraction of a node''s neighbors that are neighbors of each other.';
        CLUSTERNODE_FUNCTION = 'clustering_nodal';
        CLUSTERNODE_AVERAGE = false;
        CLUSTERNODE_STRUCTURAL = false;
        
        MODULARITY = 34;
        MODULARITY_NAME = 'modularity';
        MODULARITY_NODAL = false;
        MODULARITY_DESCRIPTION = 'The modularity is a statistic that quantifies the degree to which the graph may be subdivided into such clearly delineated groups.';
        MODULARITY_FUNCTION = 'modularity';
        MODULARITY_AVERAGE = false;
        MODULARITY_STRUCTURAL = true;
        
        BETWEENNESS = 35;
        BETWEENNESS_NAME = 'betweenness centrality';
        BETWEENNESS_NODAL = true;
        BETWEENNESS_DESCRIPTION = 'Node betweenness centrality of a node is the fraction of all shortest paths in the graph that contain a given node. Nodes with high values of betweenness centrality participate in a large number of shortest paths.';
        BETWEENNESS_FUNCTION = 'betweenness';
        BETWEENNESS_AVERAGE = false;
        BETWEENNESS_STRUCTURAL = false;
        
        CLOSENESS = 36;
        CLOSENESS_NAME = 'closeness centrality';
        CLOSENESS_NODAL = true;
        CLOSENESS_DESCRIPTION = 'The closeness centrality of a node is the inverse of the average shortest path length from the node to all other nodes in the graph.';
        CLOSENESS_FUNCTION = 'closeness';
        CLOSENESS_AVERAGE = false;
        CLOSENESS_STRUCTURAL = false;
        
        IN_CLOSENESS = 37;
        IN_CLOSENESS_NAME = 'in-closeness centrality';
        IN_CLOSENESS_NODAL = true;
        IN_CLOSENESS_DESCRIPTION = 'The in-closeness centrality of a node is the inverse of the average shortest path length from the node to all other nodes in the graph.';
        IN_CLOSENESS_FUNCTION = 'closeness_in';
        IN_CLOSENESS_AVERAGE = false;
        IN_CLOSENESS_STRUCTURAL = false;
        
        OUT_CLOSENESS = 38;
        OUT_CLOSENESS_NAME = 'in-closeness centrality';
        OUT_CLOSENESS_NODAL = true;
        OUT_CLOSENESS_DESCRIPTION = 'The in-closeness centrality of a node is the inverse of the average shortest path length from all other nodes in the graph to the node.';
        OUT_CLOSENESS_FUNCTION = 'closeness_out';
        OUT_CLOSENESS_AVERAGE = false;
        OUT_CLOSENESS_STRUCTURAL = false;
        
        ZSCORE = 39;
        ZSCORE_NAME = 'within module degree z-score';
        ZSCORE_NODAL = true;
        ZSCORE_DESCRIPTION = 'The within-module degree z-score of a node is a within-module version of degree centrality. This measure requires a previously determined community structure.';
        ZSCORE_FUNCTION = 'zscore';
        ZSCORE_AVERAGE = false;
        ZSCORE_STRUCTURAL = true;
        
        IN_ZSCORE = 40;
        IN_ZSCORE_NAME = 'within module degree in-z-score';
        IN_ZSCORE_NODAL = true;
        IN_ZSCORE_DESCRIPTION = 'The within-module degree in-z-score of a node is a within-module version of degree centrality. This measure requires a previously determined community structure.';
        IN_ZSCORE_FUNCTION = 'zscore_in';
        IN_ZSCORE_AVERAGE = false;
        IN_ZSCORE_STRUCTURAL = true;
        
        OUT_ZSCORE = 41;
        OUT_ZSCORE_NAME = 'within module degree out-z-score';
        OUT_ZSCORE_NODAL = true;
        OUT_ZSCORE_DESCRIPTION = 'The within-module degree out-z-score of a node is a within-module version of degree centrality. This measure requires a previously determined community structure.';
        OUT_ZSCORE_FUNCTION = 'zscore_out';
        OUT_ZSCORE_AVERAGE = false;
        OUT_ZSCORE_STRUCTURAL = true;
        
        PARTICIPATION = 42;
        PARTICIPATION_NAME = 'participation';
        PARTICIPATION_NODAL = true;
        PARTICIPATION_DESCRIPTION = 'The complementary participation coefficient assesses the diversity of intermodular interconnections of individual nodes. Nodes with a high within-module degree but with a low participation coefficient (known as provincial hubs) are hence likely to play an important part in the facilitation of modular segregation. On the other hand, nodes with a high participation coefficient (known as connector hubs) are likely to facilitate global intermodular integration.';
        PARTICIPATION_FUNCTION = 'participation';
        PARTICIPATION_AVERAGE = false;
        PARTICIPATION_STRUCTURAL = true;
        
        TRANSITIVITY = 43;
        TRANSITIVITY_NAME = 'transitivity';
        TRANSITIVITY_NODAL = false;
        TRANSITIVITY_DESCRIPTION = 'The transitivity is the ratio of triangles to triplets in the graph. It is an alternative to the graph clustering coefficient.';
        TRANSITIVITY_FUNCTION = 'transitivity';
        TRANSITIVITY_AVERAGE = false;
        TRANSITIVITY_STRUCTURAL = false;
        
        ECCENTRICITY = 44;
        ECCENTRICITY_NAME = 'eccentricity';
        ECCENTRICITY_NODAL = true;
        ECCENTRICITY_DESCRIPTION = 'The node eccentricity is the maximal shortest path length between a node and any other node.';
        ECCENTRICITY_FUNCTION = 'eccentricity';
        ECCENTRICITY_AVERAGE = false;
        ECCENTRICITY_STRUCTURAL = false;
        
        ECCENTRICITYAV = 45;
        ECCENTRICITYAV_NAME = 'eccentricity';
        ECCENTRICITYAV_NODAL = false;
        ECCENTRICITYAV_DESCRIPTION = 'The average eccentricity is the average node eccentricy.';
        ECCENTRICITYAV_FUNCTION = 'eccentricity';
        ECCENTRICITYAV_AVERAGE = true;
        ECCENTRICITYAV_STRUCTURAL = false;
        
        IN_ECCENTRICITY = 46;
        IN_ECCENTRICITY_NAME = 'in-eccentricity';
        IN_ECCENTRICITY_NODAL = true;
        IN_ECCENTRICITY_DESCRIPTION = 'In directed graphs, the node in-eccentricity is the maximal shortest path length from any nodes in the netwrok and a node.';
        IN_ECCENTRICITY_FUNCTION = 'eccentricity_in';
        IN_ECCENTRICITY_AVERAGE = false;
        IN_ECCENTRICITY_STRUCTURAL = false;
        
        IN_ECCENTRICITYAV = 47;
        IN_ECCENTRICITYAV_NAME = 'av. in-eccentricity';
        IN_ECCENTRICITYAV_NODAL = false;
        IN_ECCENTRICITYAV_DESCRIPTION = 'In directed graphs, the average in-eccentricity is the average node in-eccentricy.';
        IN_ECCENTRICITYAV_FUNCTION = 'eccentricity_in';
        IN_ECCENTRICITYAV_AVERAGE = true;
        IN_ECCENTRICITYAV_STRUCTURAL = false;
        
        OUT_ECCENTRICITY = 48;
        OUT_ECCENTRICITY_NAME = 'out-eccentricity';
        OUT_ECCENTRICITY_NODAL = true;
        OUT_ECCENTRICITY_DESCRIPTION = 'In directed graphs, the node out-eccentricity is the maximal shortest path length from a node to all other nodes in the netwrok.';
        OUT_ECCENTRICITY_FUNCTION = 'eccentricity_out';
        OUT_ECCENTRICITY_AVERAGE = false;
        OUT_ECCENTRICITY_STRUCTURAL = false;
        
        OUT_ECCENTRICITYAV = 49;
        OUT_ECCENTRICITYAV_NAME = 'av. out-eccentricity';
        OUT_ECCENTRICITYAV_NODAL = false;
        OUT_ECCENTRICITYAV_DESCRIPTION = 'In directed graphs, the average out-eccentricity is the average node out-eccentricy.';
        OUT_ECCENTRICITYAV_FUNCTION = 'eccentricity_out';
        OUT_ECCENTRICITYAV_AVERAGE = true;
        OUT_ECCENTRICITYAV_STRUCTURAL = false;
        
        RADIUS = 50;
        RADIUS_NAME = 'radius';
        RADIUS_NODAL = false;
        RADIUS_DESCRIPTION = 'The radius is the minimum eccentricity.';
        RADIUS_FUNCTION = 'radius';
        RADIUS_AVERAGE = false;
        RADIUS_STRUCTURAL = false;
        
        IN_RADIUS = 51;
        IN_RADIUS_NAME = 'in-radius';
        IN_RADIUS_NODAL = false;
        IN_RADIUS_DESCRIPTION = 'The in-radius is the minimum in-eccentricity.';
        IN_RADIUS_FUNCTION = 'radius_in';
        IN_RADIUS_AVERAGE = false;
        IN_RADIUS_STRUCTURAL = false;
        
        OUT_RADIUS = 52;
        OUT_RADIUS_NAME = 'out-radius';
        OUT_RADIUS_NODAL = false;
        OUT_RADIUS_DESCRIPTION = 'The out-radius is the minimum out-eccentricity.';
        OUT_RADIUS_FUNCTION = 'radius_out';
        OUT_RADIUS_AVERAGE = false;
        OUT_RADIUS_STRUCTURAL = false;
        
        DIAMETER = 53;
        DIAMETER_NAME = 'diameter';
        DIAMETER_NODAL = false;
        DIAMETER_DESCRIPTION = 'The diameter is the maximum eccentricity.'
        DIAMETER_FUNCTION = 'diameter';
        DIAMETER_AVERAGE = false;
        DIAMETER_STRUCTURAL = false;
        
        IN_DIAMETER = 54;
        IN_DIAMETER_NAME = 'in-diameter';
        IN_DIAMETER_NODAL = false;
        IN_DIAMETER_DESCRIPTION = 'The in-diameter is the maximum in-eccentricity.'
        IN_DIAMETER_FUNCTION = 'diameter_in';
        IN_DIAMETER_AVERAGE = false;
        IN_DIAMETER_STRUCTURAL = false;
        
        OUT_DIAMETER = 55;
        OUT_DIAMETER_NAME = 'out-diameter';
        OUT_DIAMETER_NODAL = false;
        OUT_DIAMETER_DESCRIPTION = 'The out-diameter is the maximum out-eccentricity.'
        OUT_DIAMETER_FUNCTION = 'diameter_out';
        OUT_DIAMETER_AVERAGE = false;
        OUT_DIAMETER_STRUCTURAL = false;
        
        CPL_WSG = 56;
        CPL_WSG_NAME = 'char. path length (within subgraphs)';
        CPL_WSG_NODAL = false;
        CPL_WSG_DESCRIPTION = 'The characteristic path length of a graph is the average shortest path length in the graph. It is the average of the path length of all nodes in the graph. This measure is calculated within subgraphs.';
        CPL_WSG_FUNCTION = 'pathlength';
        CPL_WSG_AVERAGE = true;
        CPL_WSG_STRUCTURAL = false;
        
        IN_IN_ASSORTATIVITY = 57;
        IN_IN_ASSORTATIVITY_NAME = 'in-in-assortativity';
        IN_IN_ASSORTATIVITY_NODAL = false;
        IN_IN_ASSORTATIVITY_DESCRIPTION = 'The assortativity coefficient is a correlation coefficient between the degrees/strengths of all nodes on two opposite ends of a link. A positive assortativity coefficient indicates that nodes tend to link to other nodes with the same or similar degree/strength.'
        IN_IN_ASSORTATIVITY_FUNCTION = 'assortativity_in_in';
        IN_IN_ASSORTATIVITY_AVERAGE = false;
        IN_IN_ASSORTATIVITY_STRUCTURAL = false;
        
        IN_OUT_ASSORTATIVITY = 58;
        IN_OUT_ASSORTATIVITY_NAME = 'in-out-assortativity';
        IN_OUT_ASSORTATIVITY_NODAL = false;
        IN_OUT_ASSORTATIVITY_DESCRIPTION = 'The assortativity coefficient is a correlation coefficient between the degrees/strengths of all nodes on two opposite ends of a link. A positive assortativity coefficient indicates that nodes tend to link to other nodes with the same or similar degree/strength.'
        IN_OUT_ASSORTATIVITY_FUNCTION = 'assortativity_in_out';
        IN_OUT_ASSORTATIVITY_AVERAGE = false;
        IN_OUT_ASSORTATIVITY_STRUCTURAL = false;
        
        OUT_IN_ASSORTATIVITY = 59;
        OUT_IN_ASSORTATIVITY_NAME = 'out-in-assortativity';
        OUT_IN_ASSORTATIVITY_NODAL = false;
        OUT_IN_ASSORTATIVITY_DESCRIPTION = 'The assortativity coefficient is a correlation coefficient between the degrees/strengths of all nodes on two opposite ends of a link. A positive assortativity coefficient indicates that nodes tend to link to other nodes with the same or similar degree/strength.'
        OUT_IN_ASSORTATIVITY_FUNCTION = 'assortativity_out_in';
        OUT_IN_ASSORTATIVITY_AVERAGE = false;
        OUT_IN_ASSORTATIVITY_STRUCTURAL = false;
        
        OUT_OUT_ASSORTATIVITY = 60;
        OUT_OUT_ASSORTATIVITY_NAME = 'out-out-assortativity';
        OUT_OUT_ASSORTATIVITY_NODAL = false;
        OUT_OUT_ASSORTATIVITY_DESCRIPTION = 'The assortativity coefficient is a correlation coefficient between the degrees/strengths of all nodes on two opposite ends of a link. A positive assortativity coefficient indicates that nodes tend to link to other nodes with the same or similar degree/strength.'
        OUT_OUT_ASSORTATIVITY_FUNCTION = 'assortativity_out_out';
        OUT_OUT_ASSORTATIVITY_AVERAGE = false;
        OUT_OUT_ASSORTATIVITY_STRUCTURAL = false;
        
        SW = 61;
        SW_NAME = 'small-worldness';
        SW_NODAL = false;
        SW_DESCRIPTION = 'Network small-worldness.'
        SW_FUNCTION = 'smallworldness';
        SW_AVERAGE = false;
        SW_STRUCTURAL = false;
        
        SW_WSG = 62;
        SW_WSG_NAME = 'small-worldness (within subgraphs)';
        SW_WSG_NODAL = false;
        SW_WSG_DESCRIPTION = 'Network small-worldness. This measure is calculated within subgraph'
        SW_WSG_FUNCTION = 'smallworldness';
        SW_WSG_AVERAGE = false;
        SW_WSG_STRUCTURAL = false;
        
        DISTANCE = 63;
        DISTANCE_NAME = 'distance';
        DISTANCE_NODAL = true;
        DISTANCE_DESCRIPTION = 'The distance from one node to another is the shortest path length between the two.';
        DISTANCE_FUNCTION = 'distance';
        DISTANCE_AVERAGE = false;
        DISTANCE_STRUCTURAL = false;
        
        DENSITY = 64;
        DENSITY_NAME = 'density';
        DENSITY_NODAL = true;
        DENSITY_DESCRIPTION = 'The density is the number of edges in the graph divided by the maximum number of possible edges.';
        DENSITY_FUNCTION = 'density';
        DENSITY_AVERAGE = false;
        DENSITY_STRUCTURAL = false;
        
    end
    properties (GetAccess = public, SetAccess = protected)
        A  % connection matrix
        P  % coefficient p-values
        S  % community structure
        TYPE % Graph type
        MS
    end
    properties (Access = protected)
        CS = struct('NAME', Graph.CS_NAME, 'DESCRIPTION', Graph.CS_DESCRIPTION,...
            'LAST_PARAMS', Graph.CS_LAST_PARAMS, 'VALUE', []);
        
        % N = nodenumber(g)
        N
    end
    methods (Access = protected)
        function g = Graph(A,varargin)
            % GRAPH(A) creates a graph with default properties.
            %   A is a generic connection (square, real-valued) matrix.
            %   This method is only accessible by the subclasses of Graph.
            %
            % GRAPH(A,Property1,Value1,Property2,Value2,...) initializes property
            %   Property1 to Value1, Property2 to Value2, ... .
            %   Admissible properties are:
            %       P           -   coefficient p-values
            %       structure   -   community structure object
            %   If a community structure object is not provided, one is initialized
            %   with parameters: algorithm - 'Louvain' and gamma - 1.
            %
            % See also Graph, GraphBD, GraphBU, GraphWD, GraphWU.
            
            P = zeros(size(A));  % p-values
            S = Structure('algorithm',Structure.ALGORITHM_LOUVAIN,'gamma',1);  % community structure
            for n = 1:1:length(varargin)-1
                switch varargin{n}
                    case 'p'
                        P = varargin{n+1};
                    case 'structure'
                        S = varargin{n+1};
                end
            end
            
            g.A = A;
            g.P = P;
            g.S = S;
            g.N = length(g.A);
            
            g.MS{Graph.DEGREE} = struct('NAME', Graph.DEGREE_NAME, 'NODAL', Graph.DEGREE_NODAL, 'DESCRIPTION', Graph.DEGREE_DESCRIPTION, 'FUNCTION', Graph.DEGREE_FUNCTION, 'VALUE', Graph.DEFAULT_MEASURE_VALUE, 'AVERAGE', Graph.DEGREE_AVERAGE, 'STRUCTURAL', Graph.DEGREE_STRUCTURAL);
            g.MS{Graph.DEGREEAV} = struct('NAME', Graph.DEGREEAV_NAME, 'NODAL', Graph.DEGREEAV_NODAL, 'DESCRIPTION', Graph.DEGREEAV_DESCRIPTION, 'FUNCTION', Graph.DEGREEAV_FUNCTION, 'VALUE', Graph.DEFAULT_MEASURE_VALUE, 'AVERAGE', Graph.DEGREEAV_AVERAGE, 'STRUCTURAL', Graph.DEGREEAV_STRUCTURAL);
            g.MS{Graph.IN_DEGREE} = struct('NAME', Graph.IN_DEGREE_NAME, 'NODAL', Graph.IN_DEGREE_NODAL, 'DESCRIPTION', Graph.IN_DEGREE_DESCRIPTION, 'FUNCTION', Graph.IN_DEGREE_FUNCTION, 'VALUE', Graph.DEFAULT_MEASURE_VALUE, 'AVERAGE', Graph.IN_DEGREE_AVERAGE, 'STRUCTURAL', Graph.IN_DEGREE_STRUCTURAL);
            g.MS{Graph.IN_DEGREEAV} = struct('NAME', Graph.IN_DEGREEAV_NAME, 'NODAL', Graph.IN_DEGREEAV_NODAL, 'DESCRIPTION', Graph.IN_DEGREEAV_DESCRIPTION, 'FUNCTION', Graph.IN_DEGREEAV_FUNCTION, 'VALUE', Graph.DEFAULT_MEASURE_VALUE, 'AVERAGE', Graph.IN_DEGREEAV_AVERAGE, 'STRUCTURAL', Graph.IN_DEGREEAV_STRUCTURAL);
            g.MS{Graph.OUT_DEGREE} = struct('NAME', Graph.OUT_DEGREE_NAME, 'NODAL', Graph.OUT_DEGREE_NODAL, 'DESCRIPTION', Graph.OUT_DEGREE_DESCRIPTION, 'FUNCTION', Graph.OUT_DEGREE_FUNCTION, 'VALUE', Graph.DEFAULT_MEASURE_VALUE, 'AVERAGE', Graph.OUT_DEGREE_AVERAGE, 'STRUCTURAL', Graph.OUT_DEGREE_STRUCTURAL);
            g.MS{Graph.OUT_DEGREEAV} = struct('NAME', Graph.OUT_DEGREEAV_NAME, 'NODAL', Graph.OUT_DEGREEAV_NODAL, 'DESCRIPTION', Graph.OUT_DEGREEAV_DESCRIPTION, 'FUNCTION', Graph.OUT_DEGREEAV_FUNCTION, 'VALUE', Graph.DEFAULT_MEASURE_VALUE, 'AVERAGE', Graph.OUT_DEGREEAV_AVERAGE, 'STRUCTURAL', Graph.OUT_DEGREEAV_STRUCTURAL);
            g.MS{Graph.STRENGTH} = struct('NAME', Graph.STRENGTH_NAME, 'NODAL', Graph.STRENGTH_NODAL, 'DESCRIPTION', Graph.STRENGTH_DESCRIPTION, 'FUNCTION', Graph.STRENGTH_FUNCTION, 'VALUE', Graph.DEFAULT_MEASURE_VALUE, 'AVERAGE', Graph.STRENGTH_AVERAGE, 'STRUCTURAL', Graph.STRENGTH_STRUCTURAL);
            g.MS{Graph.STRENGTHAV} = struct('NAME', Graph.STRENGTHAV_NAME, 'NODAL', Graph.STRENGTHAV_NODAL, 'DESCRIPTION', Graph.STRENGTHAV_DESCRIPTION, 'FUNCTION', Graph.STRENGTHAV_FUNCTION, 'VALUE', Graph.DEFAULT_MEASURE_VALUE, 'AVERAGE', Graph.STRENGTHAV_AVERAGE, 'STRUCTURAL', Graph.STRENGTHAV_STRUCTURAL);
            g.MS{Graph.IN_STRENGTH} = struct('NAME', Graph.IN_STRENGTH_NAME, 'NODAL', Graph.IN_STRENGTH_NODAL, 'DESCRIPTION', Graph.IN_STRENGTH_DESCRIPTION, 'FUNCTION', Graph.IN_STRENGTH_FUNCTION, 'VALUE', Graph.DEFAULT_MEASURE_VALUE, 'AVERAGE', Graph.IN_STRENGTH_AVERAGE, 'STRUCTURAL', Graph.IN_STRENGTH_STRUCTURAL);
            g.MS{Graph.IN_STRENGTHAV} = struct('NAME', Graph.IN_STRENGTHAV_NAME, 'NODAL', Graph.IN_STRENGTHAV_NODAL, 'DESCRIPTION', Graph.IN_STRENGTHAV_DESCRIPTION, 'FUNCTION', Graph.IN_STRENGTHAV_FUNCTION, 'VALUE', Graph.DEFAULT_MEASURE_VALUE, 'AVERAGE', Graph.IN_STRENGTHAV_AVERAGE, 'STRUCTURAL', Graph.IN_STRENGTHAV_STRUCTURAL);
            g.MS{Graph.OUT_STRENGTH} = struct('NAME', Graph.OUT_STRENGTH_NAME, 'NODAL', Graph.OUT_STRENGTH_NODAL, 'DESCRIPTION', Graph.OUT_STRENGTH_DESCRIPTION, 'FUNCTION', Graph.OUT_STRENGTH_FUNCTION, 'VALUE', Graph.DEFAULT_MEASURE_VALUE, 'AVERAGE', Graph.OUT_STRENGTH_AVERAGE, 'STRUCTURAL', Graph.OUT_STRENGTH_STRUCTURAL);
            g.MS{Graph.OUT_STRENGTHAV} = struct('NAME', Graph.OUT_STRENGTHAV_NAME, 'NODAL', Graph.OUT_STRENGTHAV_NODAL, 'DESCRIPTION', Graph.OUT_STRENGTHAV_DESCRIPTION, 'FUNCTION', Graph.OUT_STRENGTHAV_FUNCTION, 'VALUE', Graph.DEFAULT_MEASURE_VALUE, 'AVERAGE', Graph.OUT_STRENGTHAV_AVERAGE, 'STRUCTURAL', Graph.OUT_STRENGTHAV_STRUCTURAL);
            g.MS{Graph.TRIANGLES} = struct('NAME', Graph.TRIANGLES_NAME, 'NODAL', Graph.TRIANGLES_NODAL, 'DESCRIPTION', Graph.TRIANGLES_DESCRIPTION, 'FUNCTION', Graph.TRIANGLES_FUNCTION, 'VALUE', Graph.DEFAULT_MEASURE_VALUE, 'AVERAGE', Graph.TRIANGLES_AVERAGE, 'STRUCTURAL', Graph.TRIANGLES_STRUCTURAL);
            g.MS{Graph.CPL} = struct('NAME', Graph.CPL_NAME, 'NODAL', Graph.CPL_NODAL, 'DESCRIPTION', Graph.CPL_DESCRIPTION, 'FUNCTION', Graph.CPL_FUNCTION, 'VALUE', Graph.DEFAULT_MEASURE_VALUE, 'AVERAGE', Graph.CPL_AVERAGE, 'STRUCTURAL', Graph.CPL_STRUCTURAL);
            g.MS{Graph.PL} = struct('NAME', Graph.PL_NAME, 'NODAL', Graph.PL_NODAL, 'DESCRIPTION', Graph.PL_DESCRIPTION, 'FUNCTION', Graph.PL_FUNCTION, 'VALUE', Graph.DEFAULT_MEASURE_VALUE, 'AVERAGE', Graph.PL_AVERAGE, 'STRUCTURAL', Graph.PL_STRUCTURAL);
            g.MS{Graph.IN_CPL} = struct('NAME', Graph.IN_CPL_NAME, 'NODAL', Graph.IN_CPL_NODAL, 'DESCRIPTION', Graph.IN_CPL_DESCRIPTION, 'FUNCTION', Graph.IN_CPL_FUNCTION, 'VALUE', Graph.DEFAULT_MEASURE_VALUE, 'AVERAGE', Graph.IN_CPL_AVERAGE, 'STRUCTURAL', Graph.IN_CPL_STRUCTURAL);
            g.MS{Graph.IN_PL} = struct('NAME', Graph.IN_PL_NAME, 'NODAL', Graph.IN_PL_NODAL, 'DESCRIPTION', Graph.IN_PL_DESCRIPTION, 'FUNCTION', Graph.IN_PL_FUNCTION, 'VALUE', Graph.DEFAULT_MEASURE_VALUE, 'AVERAGE', Graph.IN_PL_AVERAGE, 'STRUCTURAL', Graph.IN_PL_STRUCTURAL);
            g.MS{Graph.OUT_CPL} = struct('NAME', Graph.OUT_CPL_NAME, 'NODAL', Graph.OUT_CPL_NODAL, 'DESCRIPTION', Graph.OUT_CPL_DESCRIPTION, 'FUNCTION', Graph.OUT_CPL_FUNCTION, 'VALUE', Graph.DEFAULT_MEASURE_VALUE, 'AVERAGE', Graph.OUT_CPL_AVERAGE, 'STRUCTURAL', Graph.OUT_CPL_STRUCTURAL);
            g.MS{Graph.OUT_PL} = struct('NAME', Graph.OUT_PL_NAME, 'NODAL', Graph.OUT_PL_NODAL, 'DESCRIPTION', Graph.OUT_PL_DESCRIPTION, 'FUNCTION', Graph.OUT_PL_FUNCTION, 'VALUE', Graph.DEFAULT_MEASURE_VALUE, 'AVERAGE', Graph.OUT_PL_AVERAGE, 'STRUCTURAL', Graph.OUT_PL_STRUCTURAL);
            g.MS{Graph.GEFF} = struct('NAME', Graph.GEFF_NAME, 'NODAL', Graph.GEFF_NODAL, 'DESCRIPTION', Graph.GEFF_DESCRIPTION, 'FUNCTION', Graph.GEFF_FUNCTION, 'VALUE', Graph.DEFAULT_MEASURE_VALUE, 'AVERAGE', Graph.GEFF_AVERAGE, 'STRUCTURAL', Graph.GEFF_STRUCTURAL);
            g.MS{Graph.GEFFNODE} = struct('NAME', Graph.GEFFNODE_NAME, 'NODAL', Graph.GEFFNODE_NODAL, 'DESCRIPTION', Graph.GEFFNODE_DESCRIPTION, 'FUNCTION', Graph.GEFFNODE_FUNCTION, 'VALUE', Graph.DEFAULT_MEASURE_VALUE, 'AVERAGE', Graph.GEFFNODE_AVERAGE, 'STRUCTURAL', Graph.GEFFNODE_STRUCTURAL);
            g.MS{Graph.IN_GEFF} = struct('NAME', Graph.IN_GEFF_NAME, 'NODAL', Graph.IN_GEFF_NODAL, 'DESCRIPTION', Graph.IN_GEFF_DESCRIPTION, 'FUNCTION', Graph.IN_GEFF_FUNCTION, 'VALUE', Graph.DEFAULT_MEASURE_VALUE, 'AVERAGE', Graph.IN_GEFF_AVERAGE, 'STRUCTURAL', Graph.IN_GEFF_STRUCTURAL);
            g.MS{Graph.IN_GEFFNODE} = struct('NAME', Graph.IN_GEFFNODE_NAME, 'NODAL', Graph.IN_GEFFNODE_NODAL, 'DESCRIPTION', Graph.IN_GEFFNODE_DESCRIPTION, 'FUNCTION', Graph.IN_GEFFNODE_FUNCTION, 'VALUE', Graph.DEFAULT_MEASURE_VALUE, 'AVERAGE', Graph.IN_GEFFNODE_AVERAGE, 'STRUCTURAL', Graph.IN_GEFFNODE_STRUCTURAL);
            g.MS{Graph.OUT_GEFF} = struct('NAME', Graph.OUT_GEFF_NAME, 'NODAL', Graph.OUT_GEFF_NODAL, 'DESCRIPTION', Graph.OUT_GEFF_DESCRIPTION, 'FUNCTION', Graph.OUT_GEFF_FUNCTION, 'VALUE', Graph.DEFAULT_MEASURE_VALUE, 'AVERAGE', Graph.OUT_GEFF_AVERAGE, 'STRUCTURAL', Graph.OUT_GEFF_STRUCTURAL);
            g.MS{Graph.OUT_GEFFNODE} = struct('NAME', Graph.OUT_GEFFNODE_NAME, 'NODAL', Graph.OUT_GEFFNODE_NODAL, 'DESCRIPTION', Graph.OUT_GEFFNODE_DESCRIPTION, 'FUNCTION', Graph.OUT_GEFFNODE_FUNCTION, 'VALUE', Graph.DEFAULT_MEASURE_VALUE, 'AVERAGE', Graph.OUT_GEFFNODE_AVERAGE, 'STRUCTURAL', Graph.OUT_GEFFNODE_STRUCTURAL);
            g.MS{Graph.LEFF} = struct('NAME', Graph.LEFF_NAME, 'NODAL', Graph.LEFF_NODAL, 'DESCRIPTION', Graph.LEFF_DESCRIPTION, 'FUNCTION', Graph.LEFF_FUNCTION, 'VALUE', Graph.DEFAULT_MEASURE_VALUE, 'AVERAGE', Graph.LEFF_AVERAGE, 'STRUCTURAL', Graph.LEFF_STRUCTURAL);
            g.MS{Graph.LEFFNODE} = struct('NAME', Graph.LEFFNODE_NAME, 'NODAL', Graph.LEFFNODE_NODAL, 'DESCRIPTION', Graph.LEFFNODE_DESCRIPTION, 'FUNCTION', Graph.LEFFNODE_FUNCTION, 'VALUE', Graph.DEFAULT_MEASURE_VALUE, 'AVERAGE', Graph.LEFFNODE_AVERAGE, 'STRUCTURAL', Graph.LEFFNODE_STRUCTURAL);
            g.MS{Graph.IN_LEFF} = struct('NAME', Graph.IN_LEFF_NAME, 'NODAL', Graph.IN_LEFF_NODAL, 'DESCRIPTION', Graph.IN_LEFF_DESCRIPTION, 'FUNCTION', Graph.IN_LEFF_FUNCTION, 'VALUE', Graph.DEFAULT_MEASURE_VALUE, 'AVERAGE', Graph.IN_LEFF_AVERAGE, 'STRUCTURAL', Graph.IN_LEFF_STRUCTURAL);
            g.MS{Graph.IN_LEFFNODE} = struct('NAME', Graph.IN_LEFFNODE_NAME, 'NODAL', Graph.IN_LEFFNODE_NODAL, 'DESCRIPTION', Graph.IN_LEFFNODE_DESCRIPTION, 'FUNCTION', Graph.IN_LEFFNODE_FUNCTION, 'VALUE', Graph.DEFAULT_MEASURE_VALUE, 'AVERAGE', Graph.IN_LEFFNODE_AVERAGE, 'STRUCTURAL', Graph.IN_LEFFNODE_STRUCTURAL);
            g.MS{Graph.OUT_LEFF} = struct('NAME', Graph.OUT_LEFF_NAME, 'NODAL', Graph.OUT_LEFF_NODAL, 'DESCRIPTION', Graph.OUT_LEFF_DESCRIPTION, 'FUNCTION', Graph.OUT_LEFF_FUNCTION, 'VALUE', Graph.DEFAULT_MEASURE_VALUE, 'AVERAGE', Graph.OUT_LEFF_AVERAGE, 'STRUCTURAL', Graph.OUT_LEFF_STRUCTURAL);
            g.MS{Graph.OUT_LEFFNODE} = struct('NAME', Graph.OUT_LEFFNODE_NAME, 'NODAL', Graph.OUT_LEFFNODE_NODAL, 'DESCRIPTION', Graph.OUT_LEFFNODE_DESCRIPTION, 'FUNCTION', Graph.OUT_LEFFNODE_FUNCTION, 'VALUE', Graph.DEFAULT_MEASURE_VALUE, 'AVERAGE', Graph.OUT_LEFFNODE_AVERAGE, 'STRUCTURAL', Graph.OUT_LEFFNODE_STRUCTURAL);
            g.MS{Graph.CLUSTER} = struct('NAME', Graph.CLUSTER_NAME, 'NODAL', Graph.CLUSTER_NODAL, 'DESCRIPTION', Graph.CLUSTER_DESCRIPTION, 'FUNCTION', Graph.CLUSTER_FUNCTION, 'VALUE', Graph.DEFAULT_MEASURE_VALUE, 'AVERAGE', Graph.CLUSTER_AVERAGE, 'STRUCTURAL', Graph.CLUSTER_STRUCTURAL);
            g.MS{Graph.CLUSTERNODE} = struct('NAME', Graph.CLUSTERNODE_NAME, 'NODAL', Graph.CLUSTERNODE_NODAL, 'DESCRIPTION', Graph.CLUSTERNODE_DESCRIPTION, 'FUNCTION', Graph.CLUSTERNODE_FUNCTION, 'VALUE', Graph.DEFAULT_MEASURE_VALUE, 'AVERAGE', Graph.CLUSTERNODE_AVERAGE, 'STRUCTURAL', Graph.CLUSTERNODE_STRUCTURAL);
            g.MS{Graph.MODULARITY} = struct('NAME', Graph.MODULARITY_NAME, 'NODAL', Graph.MODULARITY_NODAL, 'DESCRIPTION', Graph.MODULARITY_DESCRIPTION, 'FUNCTION', Graph.MODULARITY_FUNCTION, 'VALUE', Graph.DEFAULT_MEASURE_VALUE, 'AVERAGE', Graph.MODULARITY_AVERAGE, 'STRUCTURAL', Graph.MODULARITY_STRUCTURAL);
            g.MS{Graph.BETWEENNESS} = struct('NAME', Graph.BETWEENNESS_NAME, 'NODAL', Graph.BETWEENNESS_NODAL, 'DESCRIPTION', Graph.BETWEENNESS_DESCRIPTION, 'FUNCTION', Graph.BETWEENNESS_FUNCTION, 'VALUE', Graph.DEFAULT_MEASURE_VALUE, 'AVERAGE', Graph.BETWEENNESS_AVERAGE, 'STRUCTURAL', Graph.BETWEENNESS_STRUCTURAL);
            g.MS{Graph.CLOSENESS} = struct('NAME', Graph.CLOSENESS_NAME, 'NODAL', Graph.CLOSENESS_NODAL, 'DESCRIPTION', Graph.CLOSENESS_DESCRIPTION, 'FUNCTION', Graph.CLOSENESS_FUNCTION, 'VALUE', Graph.DEFAULT_MEASURE_VALUE, 'AVERAGE', Graph.CLOSENESS_AVERAGE, 'STRUCTURAL', Graph.CLOSENESS_STRUCTURAL);
            g.MS{Graph.IN_CLOSENESS} = struct('NAME', Graph.IN_CLOSENESS_NAME, 'NODAL', Graph.IN_CLOSENESS_NODAL, 'DESCRIPTION', Graph.IN_CLOSENESS_DESCRIPTION, 'FUNCTION', Graph.IN_CLOSENESS_FUNCTION, 'VALUE', Graph.DEFAULT_MEASURE_VALUE, 'AVERAGE', Graph.IN_CLOSENESS_AVERAGE, 'STRUCTURAL', Graph.IN_CLOSENESS_STRUCTURAL);
            g.MS{Graph.OUT_CLOSENESS} = struct('NAME', Graph.OUT_CLOSENESS_NAME, 'NODAL', Graph.OUT_CLOSENESS_NODAL, 'DESCRIPTION', Graph.OUT_CLOSENESS_DESCRIPTION, 'FUNCTION', Graph.OUT_CLOSENESS_FUNCTION, 'VALUE', Graph.DEFAULT_MEASURE_VALUE, 'AVERAGE', Graph.OUT_CLOSENESS_AVERAGE, 'STRUCTURAL', Graph.OUT_CLOSENESS_STRUCTURAL);
            g.MS{Graph.ZSCORE} = struct('NAME', Graph.ZSCORE_NAME, 'NODAL', Graph.ZSCORE_NODAL, 'DESCRIPTION', Graph.ZSCORE_DESCRIPTION, 'FUNCTION', Graph.ZSCORE_FUNCTION, 'VALUE', Graph.DEFAULT_MEASURE_VALUE, 'AVERAGE', Graph.ZSCORE_AVERAGE, 'STRUCTURAL', Graph.ZSCORE_STRUCTURAL);
            g.MS{Graph.IN_ZSCORE} = struct('NAME', Graph.IN_ZSCORE_NAME, 'NODAL', Graph.IN_ZSCORE_NODAL, 'DESCRIPTION', Graph.IN_ZSCORE_DESCRIPTION, 'FUNCTION', Graph.IN_ZSCORE_FUNCTION, 'VALUE', Graph.DEFAULT_MEASURE_VALUE, 'AVERAGE', Graph.IN_ZSCORE_AVERAGE, 'STRUCTURAL', Graph.IN_ZSCORE_STRUCTURAL);
            g.MS{Graph.OUT_ZSCORE} = struct('NAME', Graph.OUT_ZSCORE_NAME, 'NODAL', Graph.OUT_ZSCORE_NODAL, 'DESCRIPTION', Graph.OUT_ZSCORE_DESCRIPTION, 'FUNCTION', Graph.OUT_ZSCORE_FUNCTION, 'VALUE', Graph.DEFAULT_MEASURE_VALUE, 'AVERAGE', Graph.OUT_ZSCORE_AVERAGE, 'STRUCTURAL', Graph.OUT_ZSCORE_STRUCTURAL);
            g.MS{Graph.PARTICIPATION} = struct('NAME', Graph.PARTICIPATION_NAME, 'NODAL', Graph.PARTICIPATION_NODAL, 'DESCRIPTION', Graph.PARTICIPATION_DESCRIPTION, 'FUNCTION', Graph.PARTICIPATION_FUNCTION, 'VALUE', Graph.DEFAULT_MEASURE_VALUE, 'AVERAGE', Graph.PARTICIPATION_AVERAGE, 'STRUCTURAL', Graph.PARTICIPATION_STRUCTURAL);
            g.MS{Graph.TRANSITIVITY} = struct('NAME', Graph.TRANSITIVITY_NAME, 'NODAL', Graph.TRANSITIVITY_NODAL, 'DESCRIPTION', Graph.TRANSITIVITY_DESCRIPTION, 'FUNCTION', Graph.TRANSITIVITY_FUNCTION, 'VALUE', Graph.DEFAULT_MEASURE_VALUE, 'AVERAGE', Graph.TRANSITIVITY_AVERAGE, 'STRUCTURAL', Graph.TRANSITIVITY_STRUCTURAL);
            g.MS{Graph.ECCENTRICITY} = struct('NAME', Graph.ECCENTRICITY_NAME, 'NODAL', Graph.ECCENTRICITY_NODAL, 'DESCRIPTION', Graph.ECCENTRICITY_DESCRIPTION, 'FUNCTION', Graph.ECCENTRICITY_FUNCTION, 'VALUE', Graph.DEFAULT_MEASURE_VALUE, 'AVERAGE', Graph.ECCENTRICITY_AVERAGE, 'STRUCTURAL', Graph.ECCENTRICITY_STRUCTURAL);
            g.MS{Graph.ECCENTRICITYAV} = struct('NAME', Graph.ECCENTRICITYAV_NAME, 'NODAL', Graph.ECCENTRICITYAV_NODAL, 'DESCRIPTION', Graph.ECCENTRICITYAV_DESCRIPTION, 'FUNCTION', Graph.ECCENTRICITYAV_FUNCTION, 'VALUE', Graph.DEFAULT_MEASURE_VALUE, 'AVERAGE', Graph.ECCENTRICITYAV_AVERAGE, 'STRUCTURAL', Graph.ECCENTRICITYAV_STRUCTURAL);
            g.MS{Graph.IN_ECCENTRICITY} = struct('NAME', Graph.IN_ECCENTRICITY_NAME, 'NODAL', Graph.IN_ECCENTRICITY_NODAL, 'DESCRIPTION', Graph.IN_ECCENTRICITY_DESCRIPTION, 'FUNCTION', Graph.IN_ECCENTRICITY_FUNCTION, 'VALUE', Graph.DEFAULT_MEASURE_VALUE, 'AVERAGE', Graph.IN_ECCENTRICITY_AVERAGE, 'STRUCTURAL', Graph.IN_ECCENTRICITY_STRUCTURAL);
            g.MS{Graph.IN_ECCENTRICITYAV} = struct('NAME', Graph.IN_ECCENTRICITYAV_NAME, 'NODAL', Graph.IN_ECCENTRICITYAV_NODAL, 'DESCRIPTION', Graph.IN_ECCENTRICITYAV_DESCRIPTION, 'FUNCTION', Graph.IN_ECCENTRICITYAV_FUNCTION, 'VALUE', Graph.DEFAULT_MEASURE_VALUE, 'AVERAGE', Graph.IN_ECCENTRICITYAV_AVERAGE, 'STRUCTURAL', Graph.IN_ECCENTRICITYAV_STRUCTURAL);
            g.MS{Graph.OUT_ECCENTRICITY} = struct('NAME', Graph.OUT_ECCENTRICITY_NAME, 'NODAL', Graph.OUT_ECCENTRICITY_NODAL, 'DESCRIPTION', Graph.OUT_ECCENTRICITY_DESCRIPTION, 'FUNCTION', Graph.OUT_ECCENTRICITY_FUNCTION, 'VALUE', Graph.DEFAULT_MEASURE_VALUE, 'AVERAGE', Graph.OUT_ECCENTRICITY_AVERAGE, 'STRUCTURAL', Graph.OUT_ECCENTRICITY_STRUCTURAL);
            g.MS{Graph.OUT_ECCENTRICITYAV} = struct('NAME', Graph.OUT_ECCENTRICITYAV_NAME, 'NODAL', Graph.OUT_ECCENTRICITYAV_NODAL, 'DESCRIPTION', Graph.OUT_ECCENTRICITYAV_DESCRIPTION, 'FUNCTION', Graph.OUT_ECCENTRICITYAV_FUNCTION, 'VALUE', Graph.DEFAULT_MEASURE_VALUE, 'AVERAGE', Graph.OUT_ECCENTRICITYAV_AVERAGE, 'STRUCTURAL', Graph.OUT_ECCENTRICITYAV_STRUCTURAL);
            g.MS{Graph.RADIUS} = struct('NAME', Graph.RADIUS_NAME, 'NODAL', Graph.RADIUS_NODAL, 'DESCRIPTION', Graph.RADIUS_DESCRIPTION, 'FUNCTION', Graph.RADIUS_FUNCTION, 'VALUE', Graph.DEFAULT_MEASURE_VALUE, 'AVERAGE', Graph.RADIUS_AVERAGE, 'STRUCTURAL', Graph.RADIUS_STRUCTURAL);
            g.MS{Graph.IN_RADIUS} = struct('NAME', Graph.IN_RADIUS_NAME, 'NODAL', Graph.IN_RADIUS_NODAL, 'DESCRIPTION', Graph.IN_RADIUS_DESCRIPTION, 'FUNCTION', Graph.IN_RADIUS_FUNCTION, 'VALUE', Graph.DEFAULT_MEASURE_VALUE, 'AVERAGE', Graph.IN_RADIUS_AVERAGE, 'STRUCTURAL', Graph.IN_RADIUS_STRUCTURAL);
            g.MS{Graph.OUT_RADIUS} = struct('NAME', Graph.OUT_RADIUS_NAME, 'NODAL', Graph.OUT_RADIUS_NODAL, 'DESCRIPTION', Graph.OUT_RADIUS_DESCRIPTION, 'FUNCTION', Graph.OUT_RADIUS_FUNCTION, 'VALUE', Graph.DEFAULT_MEASURE_VALUE, 'AVERAGE', Graph.OUT_RADIUS_AVERAGE, 'STRUCTURAL', Graph.OUT_RADIUS_STRUCTURAL);
            g.MS{Graph.DIAMETER} = struct('NAME', Graph.DIAMETER_NAME, 'NODAL', Graph.DIAMETER_NODAL, 'DESCRIPTION', Graph.DIAMETER_DESCRIPTION, 'FUNCTION', Graph.DIAMETER_FUNCTION, 'VALUE', Graph.DEFAULT_MEASURE_VALUE, 'AVERAGE', Graph.DIAMETER_AVERAGE, 'STRUCTURAL', Graph.DIAMETER_STRUCTURAL);
            g.MS{Graph.IN_DIAMETER} = struct('NAME', Graph.IN_DIAMETER_NAME, 'NODAL', Graph.IN_DIAMETER_NODAL, 'DESCRIPTION', Graph.IN_DIAMETER_DESCRIPTION, 'FUNCTION', Graph.IN_DIAMETER_FUNCTION, 'VALUE', Graph.DEFAULT_MEASURE_VALUE, 'AVERAGE', Graph.IN_DIAMETER_AVERAGE, 'STRUCTURAL', Graph.IN_DIAMETER_STRUCTURAL);
            g.MS{Graph.OUT_DIAMETER} = struct('NAME', Graph.OUT_DIAMETER_NAME, 'NODAL', Graph.OUT_DIAMETER_NODAL, 'DESCRIPTION', Graph.OUT_DIAMETER_DESCRIPTION, 'FUNCTION', Graph.OUT_DIAMETER_FUNCTION, 'VALUE', Graph.DEFAULT_MEASURE_VALUE, 'AVERAGE', Graph.OUT_DIAMETER_AVERAGE, 'STRUCTURAL', Graph.OUT_DIAMETER_STRUCTURAL);
            g.MS{Graph.CPL_WSG} = struct('NAME', Graph.CPL_WSG_NAME, 'NODAL', Graph.CPL_WSG_NODAL, 'DESCRIPTION', Graph.CPL_WSG_DESCRIPTION, 'FUNCTION', Graph.CPL_WSG_FUNCTION, 'VALUE', Graph.DEFAULT_MEASURE_VALUE, 'AVERAGE', Graph.CPL_WSG_AVERAGE, 'STRUCTURAL', Graph.CPL_WSG_STRUCTURAL);
            g.MS{Graph.IN_IN_ASSORTATIVITY} = struct('NAME', Graph.IN_IN_ASSORTATIVITY_NAME, 'NODAL', Graph.IN_IN_ASSORTATIVITY_NODAL, 'DESCRIPTION', Graph.IN_IN_ASSORTATIVITY_DESCRIPTION, 'FUNCTION', Graph.IN_IN_ASSORTATIVITY_FUNCTION, 'VALUE', Graph.DEFAULT_MEASURE_VALUE, 'AVERAGE', Graph.IN_IN_ASSORTATIVITY_AVERAGE, 'STRUCTURAL', Graph.IN_IN_ASSORTATIVITY_STRUCTURAL);
            g.MS{Graph.IN_OUT_ASSORTATIVITY} = struct('NAME', Graph.IN_OUT_ASSORTATIVITY_NAME, 'NODAL', Graph.IN_OUT_ASSORTATIVITY_NODAL, 'DESCRIPTION', Graph.IN_OUT_ASSORTATIVITY_DESCRIPTION, 'FUNCTION', Graph.IN_OUT_ASSORTATIVITY_FUNCTION, 'VALUE', Graph.DEFAULT_MEASURE_VALUE, 'AVERAGE', Graph.IN_OUT_ASSORTATIVITY_AVERAGE, 'STRUCTURAL', Graph.IN_OUT_ASSORTATIVITY_STRUCTURAL);
            g.MS{Graph.OUT_IN_ASSORTATIVITY} = struct('NAME', Graph.OUT_IN_ASSORTATIVITY_NAME, 'NODAL', Graph.OUT_IN_ASSORTATIVITY_NODAL, 'DESCRIPTION', Graph.OUT_IN_ASSORTATIVITY_DESCRIPTION, 'FUNCTION', Graph.OUT_IN_ASSORTATIVITY_FUNCTION, 'VALUE', Graph.DEFAULT_MEASURE_VALUE, 'AVERAGE', Graph.OUT_IN_ASSORTATIVITY_AVERAGE, 'STRUCTURAL', Graph.OUT_IN_ASSORTATIVITY_STRUCTURAL);
            g.MS{Graph.OUT_OUT_ASSORTATIVITY} = struct('NAME', Graph.OUT_OUT_ASSORTATIVITY_NAME, 'NODAL', Graph.OUT_OUT_ASSORTATIVITY_NODAL, 'DESCRIPTION', Graph.OUT_OUT_ASSORTATIVITY_DESCRIPTION, 'FUNCTION', Graph.OUT_OUT_ASSORTATIVITY_FUNCTION, 'VALUE', Graph.DEFAULT_MEASURE_VALUE, 'AVERAGE', Graph.OUT_OUT_ASSORTATIVITY_AVERAGE, 'STRUCTURAL', Graph.OUT_OUT_ASSORTATIVITY_STRUCTURAL);
            g.MS{Graph.SW} = struct('NAME', Graph.SW_NAME, 'NODAL', Graph.SW_NODAL, 'DESCRIPTION', Graph.SW_DESCRIPTION, 'FUNCTION', Graph.SW_FUNCTION, 'VALUE', Graph.DEFAULT_MEASURE_VALUE, 'AVERAGE', Graph.SW_AVERAGE, 'STRUCTURAL', Graph.SW_STRUCTURAL);
            g.MS{Graph.SW_WSG} = struct('NAME', Graph.SW_WSG_NAME, 'NODAL', Graph.SW_WSG_NODAL, 'DESCRIPTION', Graph.SW_WSG_DESCRIPTION, 'FUNCTION', Graph.SW_WSG_FUNCTION, 'VALUE', Graph.DEFAULT_MEASURE_VALUE, 'AVERAGE', Graph.SW_WSG_AVERAGE, 'STRUCTURAL', Graph.SW_WSG_STRUCTURAL);
            g.MS{Graph.DISTANCE} = struct('NAME', Graph.DISTANCE_NAME, 'NODAL', Graph.DISTANCE_NODAL, 'DESCRIPTION', Graph.DISTANCE_DESCRIPTION, 'FUNCTION', Graph.DISTANCE_FUNCTION, 'VALUE', Graph.DEFAULT_MEASURE_VALUE, 'AVERAGE', Graph.DISTANCE_AVERAGE, 'STRUCTURAL', Graph.DISTANCE_STRUCTURAL);
            g.MS{Graph.DENSITY} = struct('NAME', Graph.DENSITY_NAME, 'NODAL', Graph.DENSITY_NODAL, 'DESCRIPTION', Graph.DENSITY_DESCRIPTION, 'FUNCTION', Graph.DENSITY_FUNCTION, 'VALUE', Graph.DEFAULT_MEASURE_VALUE, 'AVERAGE', Graph.DENSITY_AVERAGE, 'STRUCTURAL', Graph.DENSITY_STRUCTURAL);
            
        end
        function reset_structure_related_measures(g)
            % RESET_STRUCTURE_RELATED_MEASURES resets z-score and participation
            %
            % RESET_STRUCTURE_RELATED_MEASURES(G) resets all measures (z-score and
            %   participation) related to the community structure of the graph G.
            %
            % See also Graph.
            
            n_meas = length(g.MS);
            for i = 1:n_meas
                if g.MS{i}.STRUCTURAL
                    g.MS{i}.VALUE = Graph.DEFAULT_MEASURE_VALUE;
                end
            end
        end
        function cp = copyElement(g)
            % COPYELEMENT copies elements of graph
            %
            % CP = COPYELEMENT(G) copies elements of the graph G.
            %   Makes a deep copy also of the structure of the graph.
            %
            % See also Graph, handle, matlab.mixin.Copyable.
            
            % Make a shallow copy
            cp = copyElement@matlab.mixin.Copyable(g);
            % Make a deep copy
            cp.S = copy(g.S);
        end
    end
    methods (Abstract)
        weighted(g)  % weighted graph
        binary(g)  % binary graph
        directed(g)  % direced graph
        undirected(g)  % undirected graph
        distance(g)  % distance between nodes (shortest path length)
        randomize(g)  % randomize graph while preserving degree distribution
    end
    methods
        function community_structure = get_community_structure(g)
            % GET_COMMUNITY_STRUCTURE returns the current community
            %   structure
            
            graph_structure_param = g.CS.LAST_PARAMS;
            obj_structure_param = g.S.toString();
            if ~isequal(graph_structure_param, obj_structure_param)
                g.set_community_structure();
            end
            community_structure = g.CS.VALUE;
            
        end
        function set_community_structure(g)
            % SET_COMMUNITY_STRUCTURE calls the method for resetting the 
            %   current values for the structure related measures and 
            %   calls the appropriate method for calculating a new 
            %   community structure.
            
           g.reset_structure_related_measures();
           algorithm = g.S.getAlgorithm();
           switch algorithm
               case Structure.ALGORITHM_LOUVAIN
                   g.calculate_structure_louvain();
               case Structure.ALGORITHM_NEWMAN
                   g.calculate_structure_newman();
               case Structure.ALGORITHM_FIXED
                   g.calculate_structure_fixed();
           end
        end
        function type = get_type(g)
            % GET_TYPE returns the type of the graph G.
            %
            % TYPE = GET_TYPE(G) Returns the TYPE of the graph G
            %   TYPE specifies the type of graph:
            %   Graph.BD = Binary Directed
            %   Graph.BU = Binary Undirected
            %   Graph.WD = Weighted Directed
            %   Graph.WU = Weighted Undirected
            %   Graph.WDN = Weighted Directed with Negative weights
            %   Graph.WUN = Weighted Undirected with Negative weights
            
            type = g.TYPE;
        end
        function A = get_adjacency_matrix(g)
            % GET_ADJACENCY_MATRIX returns the adjacency matrix A
            % representing the graph.
            %
            % A = GET_ADJACENCY_MATRIX returns the adjacency matrix A
            % representing the graph.
            A = g.A;
        end
        function sg = subgraph(g,nodes)
            % SUBGRAPH creates subgraph from given nodes
            %
            % SG = SUBGRAPH(G,NODES) creates the graph SG as a subgraph of G
            %   containing only the nodes specified by NODES.
            %
            % See also Graph, eval.
            
            eval(['sg = ' class(g) '(g.A(nodes,nodes));'])
        end
        function ga = nodeattack(g,nodes)
            % NODEATTACK removes given nodes from a graph
            %
            % GA = NODEATTACK(G,NODES) creates the graph GA resulting by removing
            %   the nodes specified by NODES from G.
            %
            % NODES are removed by setting all the connections from and to
            %   the nodes in the connection matrix to 0.
            %
            % See also Graph, edgeattack, eval.
            
            A = g.A;
            for i = 1:1:numel(nodes)
                A(nodes(i),:) = 0;
                A(:,nodes(i)) = 0;
            end
            P = g.P;
            
            eval(['ga = ' class(g) '(A,''P'',P);'])
        end
        function ga = edgeattack(g,nodes1,nodes2)
            % EDGEATTACK removes given edges from a graph
            %
            % GA = EDGEATTACK(G,NODES1,NODES2) creates the graph GA resulting
            %   by removing the edges going from NODES1 to NODES2 from G.
            %
            % EDGES are removed by setting all the connections from NODES1 to
            %   NODES2 in the connection matrix to 0.
            %
            % NODES1 and NODES2 must have the same dimensions.
            %
            % See also Graph, nodeattack, eval.
            
            Check.samesize('The number of originating nodes is not equal to the ending nodes of an edge'...
                ,nodes1,nodes2);
            
            A = g.A;
            for i = 1:1:numel(nodes1)
                A(nodes1(i),nodes2(i)) = 0;
            end
            P = g.P;
            
            eval(['ga = ' class(g) '(A,''P'',P);'])
        end
        function N = nodenumber(g)
            % NODENUMBER number of nodes in a graph
            %
            % N = NODENUMBER(G) gets the total number of nodes of graph G.
            %
            % See also Graph.
            
            N = g.N;
        end
        function r = radius(g)
            % RADIUS radius of a graph
            %
            % R = RADIUS(G) calculates the radius R of the graph G.
            %
            % Radius is calculated as the minimum eccentricity.
            %
            % Reference: "Combinatorics and Graph theory", J.M. Harris, J.L.Hirst
            %            and M.J. Mossinghoff
            %
            % See also Graph, diameter, eccentricity.
            
            r = min(g.eccentricity());
        end
        function r = diameter(g)
            % DIAMETER diameter of a graph
            %
            % R = DIAMETER(G) calculates the diameter R of the graph G.
            %
            % Diameter is calculated as the maximum eccentricity.
            %
            % Reference: "Combinatorics and Graph theory", J.M. Harris, J.L.Hirst
            %            and M.J. Mossinghoff
            %
            % See also Graph, radius, eccentricity.
            
            r = max(g.eccentricity());
        end
        function [ecc,eccin,eccout] = eccentricity(g)
            % ECCENTRICITY eccentricity of nodes
            %
            % [ECC,ECCIN,ECCOUT] = ECCENTRICITY(G) calculates the eccentricity ECC,
            %   in-eccentricity ECCIN and out-eccentricity ECCOUT of all nodes in
            %   the graph G.
            %
            % The node eccentricity is the maximal shortest path length between a
            %   node and any other node. The eccentricity of a node is the maximum
            %   of the in and out-eccentricity of that node.
            %
            % Reference: "Combinatorics and Graph theory", J.M. Harris, J.L.Hirst
            %            and M.J. Mossinghoff
            %
            % See also Graph, distance, pl.
            
            if isempty(g.ecc) || isempty(g.eccin) || isempty(g.eccout)
                D = g.distance();
                D = Graph.removediagonal(D,Inf);
                
                g.eccin = max(D.*(D~=Inf),[],1);  % in-eccentricy = max of distance along column
                g.eccout = max(D.*(D~=Inf),[],2)';  % out-eccentricy = max of distance along column
                g.ecc = max(g.eccin,g.eccout);
            end
            
            ecc = g.ecc;
            eccin = g.eccin;
            eccout = g.eccout;
        end
        function [c,cin,cout] = pl(g)
            % PL path length of nodes
            %
            % [C,CIN,COUT] = PL(G) calculates the path length C, in-path length CIN
            %   and out-path length COUT of all nodes in the graph G.
            %
            % The path length is the average shortest path lengths of one node to all
            %   other nodes. The path length of a node is the average of the in-path
            %   and out-path length of that node.
            %
            % Reference: "Complex network measures of brain connectivity: Uses and
            %            iterpretations", M. Rubinov, O. Sporns
            %
            % See also Graph, distance.
            
            if isempty(g.c) || isempty(g.cin) || isempty(g.cout)
                D = g.distance();
                D = Graph.removediagonal(D,Inf);
                
                N = g.nodenumber();
                
                g.cin = zeros(1,N);
                for u = 1:1:N
                    Du = D(:,u);
                    g.cin(u) = sum(Du(Du~=Inf))/length(nonzeros(Du~=Inf));
                end
                
                g.cout = zeros(1,N);
                for u = 1:1:N
                    Du = D(u,:);
                    g.cout(u) = sum(Du(Du~=Inf))/length(nonzeros(Du~=Inf));
                end
                
                g.c = mean([g.cin; g.cout],1);
            end
            
            c = g.c;
            cin = g.cin;
            cout = g.cout;
        end
        function [clo,cloin,cloout] = closeness(g)
            % CLOSENESS closeness centrality of nodes
            %
            % [CLO,CLOIN,CLOOUT] = CLOSENESS(G) calculates the closeness centrality CLO,
            %   in-closeness centrality CLOIN and out-closeness centrality CLOOUT of all
            %   nodes in the graph G.
            %
            % The closeness centrality is the inverse of the average shortest path lengths
            %   of one node to all other nodes.
            %
            % See also Graph, pl.
            
            if isempty(g.clo)
                c = g.pl();
                g.clo = c.^-1;
            end
            
            if isempty(g.cloin)
                [~,cin] = g.pl();
                g.cloin = cin.^-1;
            end
            
            if isempty(g.cloout)
                [~,~,cout] = g.pl();
                g.cloout = cout.^-1;
            end
            
            clo = g.clo;
            cloin = g.cloin;
            cloout = g.cloout;
        end
        function calculate_structure_louvain(g)
            % CALCULATE_STRUCTURE_LOUVAIN community structures of a graph
            %
            % CALCULATE_STRUCTURE_LOUVAIN(G) calculate the optimal community 
            %   structure and maximized modularity in the graph G.
            %   It uses the Louvain algorithm and reads the gamma value of 
            %   the structure object to calculate the optimized community structure.
            %
            %   The optimal community structure is a structure with maximum number of
            %   edges connecting nodes within communities compared to the edges
            %   connecting nodes between communities.
            %
            %   The modularity is a parameter that signifies the degree at which the
            %   graph can be divided into distinct communities.
            
            gamma = g.S.getGamma();  % gamma from defined structure
            
            A = remove_diagonal(g.A);
            W = double(A);  % convert from logical
            n = length(W);
            s = sum(W(:));  % sum of edges (each undirected edge is counted twice)
            
            if min(W(:)) < -1e-10
                error('W must not contain negative weights.')
            end
            
            if ~exist('B','var') || isempty(B)
                B = 'modularity';
            end
            if ( ~exist('gamma','var') || isempty(gamma)) && ischar(B)
                gamma = 1;
            end
            if ~exist('M0','var') || isempty(M0)
                M0 = 1:n;
            elseif numel(M0) ~= n
                error('M0 must contain n elements.')
            end
            
            [~,~,Mb] = unique(M0);
            M = Mb;
            
            if ischar(B)
                switch B
                    case 'modularity';
                        B = W-gamma*(sum(W,2)*sum(W,1))/s;
                    case 'potts';
                        B = W-gamma*(~W);
                    otherwise;
                        error('Unknown objective function.');
                end
            else
                B = double(B);
                if ~isequal(size(W),size(B))
                    error('W and B must have the same size.')
                end
                if max(max(abs(B-B.'))) > 1e-10
                    warning('B is not symmetric, enforcing symmetry.')
                end
                if exist('gamma','var')
                    warning('Value of gamma is ignored in generalized mode.')
                end
            end
            
            B = (B+B.')/2;  % symmetrize modularity matrix
            Hnm = zeros(n,n);  % node-to-module degree
            for m = 1:max(Mb)  % loop over modules
                Hnm(:,m) = sum(B(:,Mb==m),2);
            end
            H = sum(Hnm,2);  % node degree
            Hm = sum(Hnm,1);  % module degree
            
            Q0 = -inf;
            Q = sum(B(bsxfun(@eq,M0,M0.')))/s;  % compute modularity
            first_iteration = true;
            while Q-Q0 > 1e-10
                flag = true;  % flag for within-hierarchy search
                while flag;
                    flag = false;
                    for u=randperm(n)  % loop over all nodes in random order
                        ma = Mb(u);  % current module of u
                        dQ = Hnm(u,:)-Hnm(u,ma)+B(u,u);
                        dQ(ma) = 0;  % (line above) algorithm condition
                        
                        [max_dQ mb] = max(dQ);  % maximal increase in modularity and corresponding module
                        if max_dQ > 1e-10;  % if maximal increase is positive
                            flag = true;
                            Mb(u) = mb;  % reassign module
                            
                            Hnm(:,mb) = Hnm(:,mb)+B(:,u);  % change node-to-module strengths
                            Hnm(:,ma) = Hnm(:,ma)-B(:,u);
                            Hm(mb) = Hm(mb)+H(u);  % change module strengths
                            Hm(ma) = Hm(ma)-H(u);
                        end
                    end
                end
                [~,~,Mb] = unique(Mb);  % new module assignments
                
                M0 = M;
                if first_iteration
                    M = Mb;
                    first_iteration = false;
                else
                    for u=1:n  % loop through initial module assignments
                        M(M0==u) = Mb(u);  % assign new modules
                    end
                end
                
                n = max(Mb);  % new number of modules
                B1 = zeros(n);  % new weighted matrix
                for u = 1:n
                    for v = u:n
                        bm = sum(sum(B(Mb==u,Mb==v)));  % pool weights of nodes in same module
                        B1(u,v) = bm;
                        B1(v,u) = bm;
                    end
                end
                B = B1;
                
                Mb = 1:n;  % initial module assignments
                Hnm = B;  % node-to-module strength
                H = sum(B);  % node strength
                Hm = H;  % module strength
                
                Q0 = Q;
                Q = trace(B)/s;  % compute modularity
            end
            
            g.CS.VALUE = M';
            g.CS.LAST_PARAMS = g.S.toString();
            g.MS{g.MODULARITY}.VALUE = Q;
            
        end
        function calculate_structure_newman(g)
            % CALCULATE_STRUCTURE_NEWMAN community structures of a graph
            %
            % CALCULATE_STRUCTURE_NEWMAN(G) calculate the optimal community 
            %   structure and maximized modularity in the graph G.
            %   It uses the Newman algorithm and reads the gamma value of 
            %   the structure object to calculate the optimized community structure.
            %
            %   The optimal community structure is a structure with maximum number of
            %   edges connecting nodes within communities compared to the edges
            %   connecting nodes between communities.
            %
            %   The modularity is a parameter that signifies the degree at which the
            %   graph can be divided into distinct communities.
            
            gamma = g.S.getGamma();  % gamma from defined structure
            
            A = remove_diagonal(g.A);
            N = length(A);  % number of vertices
            n_perm = randperm(N);  % randomly permute order of nodes
            A = A(n_perm,n_perm);  % DB: use permuted matrix for subsequent analysis
            
            if g.directed()
                Ki = sum(A,1);  % in-degree
                Ko = sum(A,2);  % out-degree
                m = sum(Ki);  % number of edges
                b = A-gamma*(Ko*Ki).'/m;
                B = b+b.';  % directed modularity matrix
                Ci = ones(N,1);  % community indices
                cn = 1;  % number of communities
                U = [1 0];  % array of unexamined communites
                
                ind = 1:N;
                Bg = B;
                Ng = N;
                
                while U(1)  % examine community U(1)
                    [V D] = eig(Bg);
                    [d1 i1] = max(real(diag(D)));  % most positive eigenvalue of Bg
                    v1 = V(:,i1);  % corresponding eigenvector
                    
                    S = ones(Ng,1);
                    S(v1<0) = -1;
                    q = S.'*Bg*S;  % contribution to modularity
                    
                    if q > 1e-10  % contribution positive: U(1) is divisible
                        qmax = q;  % maximal contribution to modularity
                        Bg(logical(eye(Ng))) = 0;  % Bg is modified, to enable fine-tuning
                        indg = ones(Ng,1);  % array of unmoved indices
                        Sit = S;
                        while any(indg);  % iterative fine-tuning
                            Qit = qmax-4*Sit.*(Bg*Sit);  % this line is equivalent to:
                            qmax = max(Qit.*indg);  % for i=1:Ng
                            imax = (Qit==qmax);  % Sit(i)=-Sit(i);
                            Sit(imax) = -Sit(imax);  % Qit(i)=Sit.'*Bg*Sit;
                            indg(imax) = nan;  % Sit(i)=-Sit(i);
                            if qmax > q;  % end
                                q = qmax;
                                S = Sit;
                            end
                        end
                        
                        if abs(sum(S)) == Ng  % unsuccessful splitting of U(1)
                            U(1) = [];
                        else
                            cn = cn+1;
                            Ci(ind(S==1)) = U(1);  % split old U(1) into new U(1) and into cn
                            Ci(ind(S==-1)) = cn;
                            U = [cn U];
                        end
                    else  % contribution nonpositive: U(1) is indivisible
                        U(1) = [];
                    end
                    
                    ind = find(Ci==U(1));  % indices of unexamined community U(1)
                    bg = B(ind,ind);
                    Bg = bg-diag(sum(bg));  % modularity matrix for U(1)
                    Ng = length(ind);  % number of vertices in U(1)
                end
                
                s = Ci(:,ones(1,N));  % compute modularity
                Q =~ (s-s.').*B/(2*m);
                
            elseif g.undirected()
                K = sum(A);  % degree
                m = sum(K);  % number of edges (each undirected edge is counted twice)
                B = A-gamma*(K.'*K)/m;  % modularity matrix
                Ci = ones(N,1);  % community indices
                cn = 1;  % number of communities
                U = [1 0];  % array of unexamined communites
                
                ind = 1:N;
                Bg = B;
                Ng = N;
                
                while U(1)  % examine community U(1)
                    [V D] = eig(Bg);
                    [d1 i1] = max(real(diag(D)));  % maximal positive (real part of) eigenvalue of Bg
                    v1 = V(:,i1);  % corresponding eigenvector
                    
                    S = ones(Ng,1);
                    S(v1<0) = -1;
                    q = S.'*Bg*S;  % contribution to modularity
                    
                    if q > 1e-10  % contribution positive: U(1) is divisible
                        qmax = q;  % maximal contribution to modularity
                        Bg(logical(eye(Ng))) = 0;  % Bg is modified, to enable fine-tuning
                        indg = ones(Ng,1);  % array of unmoved indices
                        Sit = S;
                        while any(indg);  % iterative fine-tuning
                            Qit = qmax-4*Sit.*(Bg*Sit);  % this line is equivalent to:
                            qmax = max(Qit.*indg);  % for i=1:Ng
                            imax = (Qit==qmax);  % Sit(i)=-Sit(i);
                            Sit(imax) = -Sit(imax);  % Qit(i)=Sit.'*Bg*Sit;
                            indg(imax) = nan;  % Sit(i)=-Sit(i);
                            if qmax > q;  % end
                                q = qmax;
                                S = Sit;
                            end
                        end
                        
                        if abs(sum(S)) == Ng  % unsuccessful splitting of U(1)
                            U(1) = [];
                        else
                            cn = cn+1;
                            Ci(ind(S==1)) = U(1);  % split old U(1) into new U(1) and into cn
                            Ci(ind(S==-1)) = cn;
                            U = [cn U];
                        end
                    else  % contribution nonpositive: U(1) is indivisible
                        U(1) = [];
                    end
                    
                    ind = find(Ci==U(1));  % indices of unexamined community U(1)
                    bg = B(ind,ind);
                    Bg = bg-diag(sum(bg));  % modularity matrix for U(1)
                    Ng = length(ind);  % number of vertices in U(1)
                end
                
                s = Ci(:,ones(1,N));  % compute modularity
                Q =~ (s-s.').*B/m;
            end
            
            Q = sum(Q(:));
            Ci_corrected = zeros(N,1);  % initialize Ci_corrected
            Ci_corrected(n_perm) = Ci;  % return order of nodes to the order used at the input stage.
            Ci = Ci_corrected;  % output corrected community assignments
            
            g.CS.VALUE = Ci';
            g.CS.LAST_PARAMS = g.S.toString();
            g.MS{g.MODULARITY}.VALUE = Q;
        end
        function calculate_structure_fixed(g)
            % CALCULATE_STRUCTURE_FIXED community structures of a graph
            %
            % CALCULATE_STRUCTURE_FIXED(G) calculate the optimal community 
            %   structure and maximized modularity in the graph G.
            %   It uses the fixed algorithm and reads the gamma value of 
            %   the structure object to calculate the optimized community structure.
            %
            %   The optimal community structure is a structure with maximum number of
            %   edges connecting nodes within communities compared to the edges
            %   connecting nodes between communities.
            %
            %   The modularity is a parameter that signifies the degree at which the
            %   graph can be divided into distinct communities.
            
            if isempty(g.S.getCi())
                g.S.setCi(ones(1, length(g.A)))
            end
            
            Ci = g.S.getCi();
            A = remove_diagonal(g.A);
            Q = 0;
            type = g.get_type();
            
            if g.undirected()
                
                L = sum(sum(A(:)))/2; % sum of link weights (divide by 2 for undirected)
                deg = degree(g.A, type);
                for i = 1:1:length(A)
                    indices = find(Ci == Ci(i));
                    indices = indices(indices~=i);
                    for j = 1:1:length(indices)
                        Q = Q + A(i,j) - deg(i)*deg(indices(j))./L;
                    end
                end
                
                
            elseif g.directed()
                
                L = sum(sum(A(:))); % sum of link weights
                indeg = degree_in(g.A, type);
                outdeg = degree_out(g.A, type);
                for i = 1:1:length(A)
                    indices = find(Ci == Ci(i));
                    indices = indices(indices~=i);
                    for j = 1:1:length(indices)
                        Q = Q + A(i,j) - outdeg(i)*indeg(indices(j))./L;
                    end
                end
            end
            
            g.CS.VALUE = Ci;
            g.CS.LAST_PARAMS = g.S.toString();
            g.MS{g.MODULARITY}.VALUE = Q/L;
        end
        function [Ci m] = structure(g)
            % STRUCTURE community structures of a graph
            %
            % [CI M] = STRUCTURE(G) calculate the optimal community structure CI in
            %   the graph G also returning the maximized modularity M.
            %   It reads the properties of the community structure provided as an
            %   input to the graph to calculate the optimized community structure.
            %
            %   The optimal community structure is a structure with maximum number of
            %   edges connecting nodes within communities compared to the edges
            %   connecting nodes between communities.
            %
            %   The modularity is a parameter that signifies the degree at which the
            %   graph can be divided into distinct communities.
            %
            % See also Graph, modularity.
            
            if g.S.isFixed()
                
                if isempty(g.S.getCi())
                    g.S.setCi(1,ones(length(g.A)))
                end
                
                Ci = g.S.getCi();
                
                A = Graph.removediagonal(g.A,0);
                Q = 0;
                
                if g.undirected()
                    
                    L = sum(sum(A(:)))/2; % sum of link weights (divide by 2 for undirected)
                    degree = g.degree();
                    for i = 1:1:length(A)
                        indices = find(Ci == Ci(i));
                        indices = indices(indices~=i);
                        for j = 1:1:length(indices)
                            Q = Q + A(i,j) - degree(i)*degree(indices(j))./L;
                        end
                    end
                    
                    
                elseif g.directed()
                    
                    L = sum(sum(A(:))); % sum of link weights
                    [~,ind,outd] = g.degree();
                    for i = 1:1:length(A)
                        indices = find(Ci == Ci(i));
                        indices = indices(indices~=i);
                        for j = 1:1:length(indices)
                            Q = Q + A(i,j) - outd(i)*ind(indices(j))./L;
                        end
                    end
                end
                
                
                g.m = Q/L;
                m = g.m;
                
            else
                algorithm = g.S.getAlgorithm();  % algorithm from defined structure
                gamma = g.S.getGamma();  % gamma from defined structure
                
                switch algorithm
                    
                    case Structure.ALGORITHM_LOUVAIN
                        
                        A = Graph.removediagonal(g.A,0);
                        W = double(A);  % convert from logical
                        n = length(W);
                        s = sum(W(:));  % sum of edges (each undirected edge is counted twice)
                        
                        if min(W(:)) < -1e-10
                            error('W must not contain negative weights.')
                        end
                        
                        if ~exist('B','var') || isempty(B)
                            B = 'modularity';
                        end
                        if ( ~exist('gamma','var') || isempty(gamma)) && ischar(B)
                            gamma = 1;
                        end
                        if ~exist('M0','var') || isempty(M0)
                            M0 = 1:n;
                        elseif numel(M0) ~= n
                            error('M0 must contain n elements.')
                        end
                        
                        [~,~,Mb] = unique(M0);
                        M = Mb;
                        
                        if ischar(B)
                            switch B
                                case 'modularity';
                                    B = W-gamma*(sum(W,2)*sum(W,1))/s;
                                case 'potts';
                                    B = W-gamma*(~W);
                                otherwise;
                                    error('Unknown objective function.');
                            end
                        else
                            B = double(B);
                            if ~isequal(size(W),size(B))
                                error('W and B must have the same size.')
                            end
                            if max(max(abs(B-B.'))) > 1e-10
                                warning('B is not symmetric, enforcing symmetry.')
                            end
                            if exist('gamma','var')
                                warning('Value of gamma is ignored in generalized mode.')
                            end
                        end
                        
                        B = (B+B.')/2;  % symmetrize modularity matrix
                        Hnm = zeros(n,n);  % node-to-module degree
                        for m = 1:max(Mb)  % loop over modules
                            Hnm(:,m) = sum(B(:,Mb==m),2);
                        end
                        H = sum(Hnm,2);  % node degree
                        Hm = sum(Hnm,1);  % module degree
                        
                        Q0 = -inf;
                        Q = sum(B(bsxfun(@eq,M0,M0.')))/s;  % compute modularity
                        first_iteration = true;
                        while Q-Q0 > 1e-10
                            flag = true;  % flag for within-hierarchy search
                            while flag;
                                flag = false;
                                for u=randperm(n)  % loop over all nodes in random order
                                    ma = Mb(u);  % current module of u
                                    dQ = Hnm(u,:)-Hnm(u,ma)+B(u,u);
                                    dQ(ma) = 0;  % (line above) algorithm condition
                                    
                                    [max_dQ mb] = max(dQ);  % maximal increase in modularity and corresponding module
                                    if max_dQ > 1e-10;  % if maximal increase is positive
                                        flag = true;
                                        Mb(u) = mb;  % reassign module
                                        
                                        Hnm(:,mb) = Hnm(:,mb)+B(:,u);  % change node-to-module strengths
                                        Hnm(:,ma) = Hnm(:,ma)-B(:,u);
                                        Hm(mb) = Hm(mb)+H(u);  % change module strengths
                                        Hm(ma) = Hm(ma)-H(u);
                                    end
                                end
                            end
                            [~,~,Mb] = unique(Mb);  % new module assignments
                            
                            M0 = M;
                            if first_iteration
                                M = Mb;
                                first_iteration = false;
                            else
                                for u=1:n  % loop through initial module assignments
                                    M(M0==u) = Mb(u);  % assign new modules
                                end
                            end
                            
                            n = max(Mb);  % new number of modules
                            B1 = zeros(n);  % new weighted matrix
                            for u = 1:n
                                for v = u:n
                                    bm = sum(sum(B(Mb==u,Mb==v)));  % pool weights of nodes in same module
                                    B1(u,v) = bm;
                                    B1(v,u) = bm;
                                end
                            end
                            B = B1;
                            
                            Mb = 1:n;  % initial module assignments
                            Hnm = B;  % node-to-module strength
                            H = sum(B);  % node strength
                            Hm = H;  % module strength
                            
                            Q0 = Q;
                            Q = trace(B)/s;  % compute modularity
                        end
                        
                        g.Ci = M';
                        g.m = Q;
                        
                    case Structure.ALGORITHM_NEWMAN
                        
                        if g.directed()
                            A = Graph.removediagonal(g.A,0);
                            N = length(A);  % number of vertices
                            n_perm = randperm(N);  % randomly permute order of nodes
                            A = A(n_perm,n_perm);  % DB: use permuted matrix for subsequent analysis
                            Ki = sum(A,1);  % in-degree
                            Ko = sum(A,2);  % out-degree
                            m = sum(Ki);  % number of edges
                            b = A-gamma*(Ko*Ki).'/m;
                            B = b+b.';  % directed modularity matrix
                            Ci = ones(N,1);  % community indices
                            cn = 1;  % number of communities
                            U = [1 0];  % array of unexamined communites
                            
                            ind = 1:N;
                            Bg = B;
                            Ng = N;
                            
                            while U(1)  % examine community U(1)
                                [V D] = eig(Bg);
                                [d1 i1] = max(real(diag(D)));  % most positive eigenvalue of Bg
                                v1 = V(:,i1);  % corresponding eigenvector
                                
                                S = ones(Ng,1);
                                S(v1<0) = -1;
                                q = S.'*Bg*S;  % contribution to modularity
                                
                                if q > 1e-10  % contribution positive: U(1) is divisible
                                    qmax = q;  % maximal contribution to modularity
                                    Bg(logical(eye(Ng))) = 0;  % Bg is modified, to enable fine-tuning
                                    indg = ones(Ng,1);  % array of unmoved indices
                                    Sit = S;
                                    while any(indg);  % iterative fine-tuning
                                        Qit = qmax-4*Sit.*(Bg*Sit);  % this line is equivalent to:
                                        qmax = max(Qit.*indg);  % for i=1:Ng
                                        imax = (Qit==qmax);  % Sit(i)=-Sit(i);
                                        Sit(imax) = -Sit(imax);  % Qit(i)=Sit.'*Bg*Sit;
                                        indg(imax) = nan;  % Sit(i)=-Sit(i);
                                        if qmax > q;  % end
                                            q = qmax;
                                            S = Sit;
                                        end
                                    end
                                    
                                    if abs(sum(S)) == Ng  % unsuccessful splitting of U(1)
                                        U(1) = [];
                                    else
                                        cn = cn+1;
                                        Ci(ind(S==1)) = U(1);  % split old U(1) into new U(1) and into cn
                                        Ci(ind(S==-1)) = cn;
                                        U = [cn U];
                                    end
                                else  % contribution nonpositive: U(1) is indivisible
                                    U(1) = [];
                                end
                                
                                ind = find(Ci==U(1));  % indices of unexamined community U(1)
                                bg = B(ind,ind);
                                Bg = bg-diag(sum(bg));  % modularity matrix for U(1)
                                Ng = length(ind);  % number of vertices in U(1)
                            end
                            
                            s = Ci(:,ones(1,N));  % compute modularity
                            Q =~ (s-s.').*B/(2*m);
                            Q = sum(Q(:));
                            Ci_corrected = zeros(N,1);  % initialize Ci_corrected
                            Ci_corrected(n_perm) = Ci;  % return order of nodes to the order used at the input stage.
                            Ci = Ci_corrected;  % output corrected community assignments
                            
                            g.Ci = Ci';
                            g.m = Q;
                            
                        elseif g.undirected()
                            A = Graph.removediagonal(g.A,0);
                            N = length(A);  % number of vertices
                            n_perm = randperm(N);  % randomly permute order of nodes
                            A = A(n_perm,n_perm);  % DB: use permuted matrix for subsequent analysis
                            K = sum(A);  % degree
                            m = sum(K);  % number of edges (each undirected edge is counted twice)
                            B = A-gamma*(K.'*K)/m;  % modularity matrix
                            Ci = ones(N,1);  % community indices
                            cn = 1;  % number of communities
                            U = [1 0];  % array of unexamined communites
                            
                            ind = 1:N;
                            Bg = B;
                            Ng = N;
                            
                            while U(1)  % examine community U(1)
                                [V D] = eig(Bg);
                                [d1 i1] = max(real(diag(D)));  % maximal positive (real part of) eigenvalue of Bg
                                v1 = V(:,i1);  % corresponding eigenvector
                                
                                S = ones(Ng,1);
                                S(v1<0) = -1;
                                q = S.'*Bg*S;  % contribution to modularity
                                
                                if q > 1e-10  % contribution positive: U(1) is divisible
                                    qmax = q;  % maximal contribution to modularity
                                    Bg(logical(eye(Ng))) = 0;  % Bg is modified, to enable fine-tuning
                                    indg = ones(Ng,1);  % array of unmoved indices
                                    Sit = S;
                                    while any(indg);  % iterative fine-tuning
                                        Qit = qmax-4*Sit.*(Bg*Sit);  % this line is equivalent to:
                                        qmax = max(Qit.*indg);  % for i=1:Ng
                                        imax = (Qit==qmax);  % Sit(i)=-Sit(i);
                                        Sit(imax) = -Sit(imax);  % Qit(i)=Sit.'*Bg*Sit;
                                        indg(imax) = nan;  % Sit(i)=-Sit(i);
                                        if qmax > q;  % end
                                            q = qmax;
                                            S = Sit;
                                        end
                                    end
                                    
                                    if abs(sum(S)) == Ng  % unsuccessful splitting of U(1)
                                        U(1) = [];
                                    else
                                        cn = cn+1;
                                        Ci(ind(S==1)) = U(1);  % split old U(1) into new U(1) and into cn
                                        Ci(ind(S==-1)) = cn;
                                        U = [cn U];
                                    end
                                else  % contribution nonpositive: U(1) is indivisible
                                    U(1) = [];
                                end
                                
                                ind = find(Ci==U(1));  % indices of unexamined community U(1)
                                bg = B(ind,ind);
                                Bg = bg-diag(sum(bg));  % modularity matrix for U(1)
                                Ng = length(ind);  % number of vertices in U(1)
                            end
                            
                            s = Ci(:,ones(1,N));  % compute modularity
                            Q =~ (s-s.').*B/m;
                            Q = sum(Q(:));
                            Ci_corrected = zeros(N,1);  % initialize Ci_corrected
                            Ci_corrected(n_perm) = Ci;  % return order of nodes to the order used at the input stage.
                            Ci = Ci_corrected;  % output corrected community assignments
                            
                            g.Ci = Ci';
                            g.m = Q;
                        end
                end
                
                Ci = g.Ci;
                m = g.m;
            end
            
            reset_structure_related_measures(g)
        end
        function [z,zin,zout] = zscore(g)
            % ZSCORE within module degree z-score
            %
            % [Z, ZIN, ZOUT] = ZSCORE(G) calculates the within-module degree z-score Z,
            %   in-z-score ZIN and out-z-score ZOUT of nodes included in graph G.
            %   Before the z-score can be calculated, a custom structure should be provided
            %   as input to the graph, or alternatively the function G.structure() should be
            %   called to calculate the optimized community structure.
            %
            % The within-module degree z-score is a within-module version of degree
            %   centrality. It measures how well a node is connected to the other
            %   nodes in the same community.
            %
            % See also Graph, Structure.
            
            if isempty(g.z)
                W = g.A+g.A.';
                
                N = length(W);
                Ci = g.structure();
                Z = zeros(1,N);
                for i = 1:1:max(Ci)
                    Koi = sum(W(Ci==i,Ci==i),2);
                    Z(Ci==i) = (Koi-mean(Koi))./std(Koi);
                end
                
                Z(isnan(Z)) = 0;
                
                g.z = Z;
            end
            
            if nargout>1 && isempty(g.zin)
                W = g.A;
                
                N = length(W);
                Ci = g.structure();
                Z = zeros(1,N);
                for i = 1:1:max(Ci)
                    Koi = sum(W(Ci==i,Ci==i),2);
                    Z(Ci==i) = (Koi-mean(Koi))./std(Koi);
                end
                
                Z(isnan(Z)) = 0;
                
                g.zin = Z;
            end
            
            if nargout>2 && isempty(g.zout)
                W = g.A.';
                
                N = length(W);
                Ci = g.structure();
                Z = zeros(1,N);
                for i = 1:1:max(Ci)
                    Koi = sum(W(Ci==i,Ci==i),2);
                    Z(Ci==i) = (Koi-mean(Koi))./std(Koi);
                end
                
                Z(isnan(Z)) = 0;
                
                g.zout = Z;
            end
            
            z = g.z;
            zin = g.zin;
            zout = g.zout;
        end
        function p = participation(g)
            % PARTICIPATION participation coefficient of nodes
            %
            % P = PARTICIPATION(G) calculates the participation coefficient of
            %   a node from the graph G in a given community.
            %   Before the participation coefficient can be calculated, a custom structure
            %   should be provided as input to the graph, or alternatively the function
            %   g.structure() should be called to calculate the optimized community structure.
            %
            % The participation coefficient shows the node connectivity through the
            %   availible communities. It is expressed by the ratio of the edges that
            %   a node forms within a community to the total number of edges the node
            %   forms whithin the whole graph.
            %
            % See also Graph, Structure.
            
            if isempty(g.p)
                W = g.A;
                Ci = g.structure();
                
                n = length(W);  % number of vertices
                Ko = sum(W,2);  % (out)degree
                Gc = (W~=0)*diag(Ci);  % neighbor community affiliation
                Kc2 = zeros(n,1);  % community-specific neighbors
                
                for i = 1:1:max(Ci)
                    Kc2 = Kc2+(sum(W.*(Gc==i),2).^2);
                end
                
                P = ones(n,1)-Kc2./(Ko.^2);
                P(~Ko) = 0;  % P=0 if for nodes with no (out)neighbors
                
                g.p = P';
            end
            
            p = g.p;
        end
        function sw = smallworldness(g,wsg)
            % SMALLWORLDNESS small-worldness of the graph
            %
            % SW = SMALLWORLDNESS(G,WGS) calculated the small-worldness of the graph.
            %   WGS = true means that it is calcualted using
            %   the characteristic path length within connected subgraphs.
            %
            % SW = SMALLWORLDNESS(G) is equivalent to SW = SMALLWORLDNESS(G,false)
            %
            % See also Graph.
            
            if nargin<2
                wsg = false;
            end
            
            M = 100;  % number of random graphs
            
            if isempty(g.sw)
                C = g.measure(Graph.CLUSTER);
                if g.directed() || ~wsg
                    L = g.measure(Graph.CPL);
                else
                    L = g.measure(Graph.CPL_WSG);
                end
                
                Cr = zeros(1,M);
                Lr = zeros(1,M);
                for m = 1:1:M
                    gr = g.randomize();
                    Cr(m) = gr.measure(Graph.CLUSTER);
                    if g.directed()
                        Lr(m) = gr.measure(Graph.CPL);
                    else
                        Lr(m) = gr.measure(Graph.CPL_WSG);
                    end
                end
                Cr = mean(Cr);
                Lr = mean(Lr);
                
                g.sw = (C/Cr)/(L/Lr);
            end
            
            sw = g.sw;
        end
        function calculate_measure(g,mi)
            % CALCULATE_MEASURE calculates a given measure
            %
            % CALCULATE_MEASURE(G,MI) calculates the measure given by the
            % index MI of the graph G.
            
            % Check if it's a valid measure
            if mi <= 0
                error('Negative measure input')
            end
            
            if mi > length(g.MS)
                error('Too large measure input')
            end
            
            % Check if measure has already been calculated
            if ~isempty(g.MS{mi}.VALUE)
                return
            end
            
            % Special case for modularity
            if mi == Graph.MODULARITY
                g.get_community_structure()
                return
            end
            
            % Evaluate the measure
            if g.MS{mi}.AVERAGE
                g.MS{mi}.VALUE = feval('calculate_average', g.MS{mi}.FUNCTION, g.get_adjacency_matrix(), g.get_type());
            elseif g.MS{mi}.STRUCTURAL
                g.MS{mi}.VALUE = feval(g.MS{mi}.FUNCTION, g.get_adjacency_matrix(), g.get_type(), g.get_community_structure());
            else
                g.MS{mi}.VALUE = feval(g.MS{mi}.FUNCTION, g.get_adjacency_matrix(), g.get_type());
            end
        end
    end
    methods (Static)
        function B = removediagonal(A,value)
            % REMOVEDIAGONAL replaces matrix diagonal with given value
            %
            % B = REMOVEDIAGONAL(A,VALUE) sets the values in the diagonal of any
            %   matrix A to VALUE and returns the resulting matrix B.
            %   If VALUE is not inputted, the default is 0.
            %
            % See also Graph.
            
            if nargin < 2
                value = 0;
            end
            
            B = A;
            B(1:length(A)+1:numel(A)) = value;
        end
        function B = symmetrize(A,varargin)
            % SYMMETRIZE symmetrizes a matrix
            %
            % B = SYMMETRIZE(A) symmetrizes any matrix A and returns the resulting
            %   symmetric matrix B.
            %
            % B = SYMMETRIZE(A,'PropertyName',PropertyValue) symmetrizes the matrix
            %   A by the property PropertyName specified by the PropertyValue.
            %   Admissible properties are:
            %       rule    -   'max' (default) | 'min' | 'av' | 'sum'
            %                   'max' - maximum between inconnection and outconnection (default)
            %                   'min' - minimum between inconnection and outconnection
            %                   'av'  - average of inconnection and outconnection
            %                   'sum' - sum of inconnection and outconnection
            %
            % See also Graph.
            
            % Rule
            rule = 'max';
            for n = 1:1:length(varargin)-1
                if strcmpi(varargin{n},'rule')
                    rule = varargin{n+1};
                end
            end
            
            switch lower(rule)
                case {'sum','add'}  % sum rule
                    B = A+transpose(A);
                case {'av','average'}  % average rule
                    B = (A+transpose(A))/2;
                case {'min','minimum','or','weak'}  % minimum rule
                    B = min(A,transpose(A));
                otherwise  % {'max','maximum','and','strong'} % maximum rule
                    B = max(A,transpose(A));
            end
        end
        function [count,bins,density] = histogram(A,varargin)
            % HISTOGRAM histogram of a matrix
            %
            % [COUNT,BINS,DENSITY] = HISTOGRAM(A) calculates the histogram of matrix A
            %   and finds the frequency of data COUNT in the intervals BINS at which histogram
            %   is plotted, and associated DENSITY.
            %
            % [COUNT,BINS,DENSITY] = HISTOGRAM(A,'PropertyName',PropertyValue) calculates
            %   the histogram of A by using the property PropertyName specified by the
            %   PropertyValue.
            %   Admissible properties are:
            %       bins       -   -1:.001:1 (default)
            %       diagonal   -   'exclude' (default) | 'include'
            %
            % See also Graph, hist.
            
            % Bins
            bins = -1:.001:1;
            for n = 1:1:length(varargin)-1
                if strcmpi(varargin{n},'bins')
                    bins = varargin{n+1};
                end
            end
            
            % Diagonal
            diagonal = 'exclude';
            for n = 1:1:length(varargin)-1
                if strcmpi(varargin{n},'diagonal')
                    diagonal = varargin{n+1};
                end
            end
            
            % Analysis
            if strcmp(diagonal,'include')
                count = hist(reshape(A,1,numel(A)),bins);
                density = 1-cumsum(count)/numel(A);
            else
                B = A(~eye(size(A)));
                count = hist(B,bins);
                density = 1-cumsum(count)/numel(B);
            end
            
            density = density*100;
        end
        function [B,threshold] = binarize(A,varargin)
            % BINARIZE binarizes a matrix
            %
            % [B,THRESHOLD] = BINARIZE(A) binarizes the matrix A by fixing either the
            %   threshold (default, threshold=0) or the density (percent of connections).
            %   It returns the binarized matrix B and the threshold THRESHOLD.
            %
            % [B,THRESHOLD] = BINARIZE(A,'PropertyName',PropertyValue) binarizes the
            %   matrix A by using the property PropertyName specified by the PropertyValue.
            %   Admissible properties are:
            %       threshold   -   0 (default)
            %       bins        -   -1:.001:1 (default)
            %       density     -   percentage of connections
            %       diagonal    -   'exclude' (default) | 'include'
            %
            % See also Graph, histogram.
            
            % Threshold and density
            threshold = 0;
            for n = 1:1:length(varargin)-1
                if strcmpi(varargin{n},'threshold')
                    threshold = varargin{n+1};
                end
            end
            for n = 1:1:length(varargin)-1
                if strcmpi(varargin{n},'density')
                    [~,bins,density] = Graph.histogram(A,varargin{:});
                    threshold = bins(density<varargin{n+1});
                    if isempty(threshold)
                        threshold = 1;
                    else
                        threshold = threshold(1);
                    end
                end
            end
            
            % Calculates binary graph
            B = zeros(size(A));
            B(A>threshold) = 1;
        end
        function h = plotw(A,varargin)
            % PLOTW plots a weighted matrix
            %
            % H = PLOTW(A) plots the weighted matrix A and returns the handle to
            %   the plot H.
            %
            % H = PLOTW(A,'PropertyName',PropertyValue) sets the property of the
            %   matrix plot PropertyName to PropertyValue.
            %   All standard plot properties of surf can be used.
            %   Additional admissive properties are:
            %       xlabels   -   1:1:number of matrix elements (default)
            %       ylabels   -   1:1:number of matrix elements (default)
            %
            % See also Graph, plotb, surf.
            
            N = length(A);
            
            % x labels
            xlabels = (1:1:N);
            for n = 1:2:length(varargin)
                if strcmpi(varargin{n},'xlabels')
                    xlabels = varargin{n+1};
                end
            end
            if ~iscell(xlabels)
                xlabels = {xlabels};
            end
            
            % y labels
            ylabels = (1:1:N);
            for n = 1:2:length(varargin)
                if strcmpi(varargin{n},'ylabels')
                    ylabels = varargin{n+1};
                end
            end
            if ~iscell(ylabels)
                ylabels = {ylabels};
            end
            
            ht = surf((0:1:N), ...
                (0:1:N), ...
                [A, zeros(size(A,1),1); zeros(1,size(A,1)+1)]);
            view(2)
            shading flat
            axis equal square tight
            grid off
            box on
            set(gca, ...
                'XAxisLocation','top', ...
                'XTick',(1:1:N)-.5, ...
                'XTickLabel',{}, ...
                'YAxisLocation','left', ...
                'YDir','Reverse', ...
                'YTick',(1:1:N)-.5, ...
                'YTickLabel',ylabels)
            
            if ~verLessThan('matlab', '8.4.0')
                set(gca, ...
                    'XTickLabelRotation',90, ...
                    'XTickLabel',xlabels)
            else
                t = text((1:1:N)-.5,zeros(1,N),xlabels);
                set(t, ...
                    'HorizontalAlignment','left', ...
                    'VerticalAlignment','middle', ...
                    'Rotation',90);
            end
            
            colormap jet
            
            % output if needed
            if nargout>0
                h = ht;
            end
        end
        function h = plotb(A,varargin)
            % PLOTB plots a binary matrix
            %
            % H = PLOTB(A) plots the binarized version of weighted matrix A and
            %   returns the handle to the plot H.
            %   The matrix A can be binarized by fixing the threshold
            %   (default, threshold=0.5).
            %
            % H = PLOTB(A,'PropertyName',PropertyValue) sets the property of the
            %   matrix plot PropertyName to PropertyValue.
            %   All standard plot properties of surf can be used.
            %   Additional admissive properties are:
            %       threshold   -   0.5 (default)
            %       xlabels     -   1:1:number of matrix elements (default)
            %       ylabels     -   1:1:number of matrix elements (default)
            %
            % See also Graph, binarize, plotw, surf.
            
            N = length(A);
            
            % threshold
            threshold = .5;
            for n = 1:2:length(varargin)
                if strcmpi(varargin{n},'threshold')
                    threshold = varargin{n+1};
                end
            end
            
            % x labels
            xlabels = (1:1:N);
            for n = 1:2:length(varargin)
                if strcmpi(varargin{n},'xlabels')
                    xlabels = varargin{n+1};
                end
            end
            if ~iscell(xlabels)
                xlabels = {xlabels};
            end
            
            % y labels
            ylabels = (1:1:N);
            for n = 1:2:length(varargin)
                if strcmpi(varargin{n},'ylabels')
                    ylabels = varargin{n+1};
                end
            end
            if ~iscell(ylabels)
                ylabels = {ylabels};
            end
            
            B = Graph.binarize(A,'threshold',threshold);
            
            ht = surf((0:1:N), ...
                (0:1:N), ...
                [B, zeros(size(B,1),1); zeros(1,size(B,1)+1)]);
            view(2)
            shading flat
            axis equal square tight
            grid off
            box on
            set(gca, ...
                'XAxisLocation','top', ...
                'XTick',(1:1:N)-.5, ...
                'XTickLabel',{}, ...
                'YAxisLocation','left', ...
                'YDir','Reverse', ...
                'YTick',(1:1:N)-.5, ...
                'YTickLabel',ylabels)
            
            if ~verLessThan('matlab', '8.4.0')
                set(gca, ...
                    'XTickLabelRotation',90, ...
                    'XTickLabel',xlabels)
            else
                t = text((1:1:N)-.5,zeros(1,N),xlabels);
                set(t, ...
                    'HorizontalAlignment','left', ...
                    'VerticalAlignment','middle', ...
                    'Rotation',90);
            end
            
            colormap bone
            
            % output if needed
            if nargout>0
                h = ht;
            end
        end
        function h = hist(A,varargin)
            % HIST plots the histogram and density of a matrix
            %
            % H = HIST(A) plots the histogram of a matrix A and the associated density and
            %   returns the handle to the plot H.
            %
            % H = HIST(A,'PropertyName',PropertyValue) sets the property of the histogram
            %   plot PropertyName to PropertyValue.
            %   All standard plot properties of surf can be used.
            %   Additional admissive properties are:
            %       bins       -   -1:.001:1 (default)
            %       diagonal   -   'exclude' (default) | 'include'
            %
            % See also Graph, histogram.
            
            [count,bins,density] = Graph.histogram(A,varargin{:});
            
            bins = [bins(1) bins bins(end)];
            count = [0 count 0];
            density = [100 density 0];
            
            hold on
            ht1 = fill(bins,count,'k');
            ht2 = plot(bins,density,'b','linewidth',2);
            hold off
            xlabel('coefficient values / threshold')
            ylabel('coefficient counts / density')
            
            grid off
            box on
            axis square tight
            set(gca, ...
                'XAxisLocation','bottom', ...
                'XTickLabelMode','auto', ...
                'XTickMode','auto', ...
                'YTickLabelMode','auto', ...
                'YAxisLocation','left', ...
                'YDir','Normal', ...
                'YTickMode','auto', ...
                'YTickLabelMode','auto')
            
            % output if needed
            if nargout>0
                h = [ht1 ht2];
            end
        end
        function bool = isnodal(mi)
            % ISNODAL checks if measure is nodal
            %
            % BOOL = ISNODAL(MI) returns true if measure MI is nodal and false otherwise.
            %
            % See also Graph, isglobal.
            
            bool = Graph.NODAL(mi);
        end
        function bool = isglobal(mi)
            % ISGLOBAL checks if measure is global
            %
            % BOOL = ISGLOBAL(MI) returns true if measure MI is global and false otherwise.
            %
            % See also Graph, isnodal.
            
            bool = ~Graph.isnodal(mi);
        end
        function bool = is_directed(arg)
            % IS_DIRECTED checks if the graph type is directed
            %
            % BOOL = IS_DIRECTED(TYPE) returns true if TYPE corresponds to
            %   a directed graph type, false otherwise.
            %   TYPE specifies the type of graph:
            %   Graph.BD = Binary Directed
            %   Graph.BU = Binary Undirected
            %   Graph.WD = Weighted Directed
            %   Graph.WU = Weighted Undirected
            %   Graph.WDN = Weighted Directed with Negative weights
            %   Graph.WUN = Weighted Undirected with Negative weights
            %
            % BOOL = IS_DIRECTED(GRAPH) returns true if GRAPH is a directed
            %   graph, false otherwise.
            
            if isnumeric(arg)  % if graph type as input
                type = arg;
            else  % if graph object as input
                type = arg.get_type();
            end
            
            bool = type==Graph.BD || type==Graph.WD || type==Graph.WDN;
        end
        function bool = is_undirected(arg)
            % IS_UNDIRECTED checks if the graph type is undirected
            %
            % BOOL = IS_UNDIRECTED(TYPE) returns true if TYPE corresponds to
            %   an undirected graph type, false otherwise.
            %   TYPE specifies the type of graph:
            %   Graph.BD = Binary Directed
            %   Graph.BU = Binary Undirected
            %   Graph.WD = Weighted Directed
            %   Graph.WU = Weighted Undirected
            %   Graph.WDN = Weighted Directed with Negative weights
            %   Graph.WUN = Weighted Undirected with Negative weights
            %
            % BOOL = IS_UNDIRECTED(GRAPH) returns true if GRAPH is an udirected
            %   graph, false otherwise.
            
            if isnumeric(arg)  % if graph type as input
                type = arg;
            else  % if graph object as input
                type = arg.get_type();
            end
            
            bool = type==Graph.BU || type==Graph.WU || type==Graph.WUN;
        end
        function bool = is_binary(arg)
            % IS_BINARY checks if the graph type is binary
            %
            % BOOL = IS_BINARY(TYPE) returns true if TYPE corresponds to
            %   a binary graph type, false otherwise.
            %   TYPE specifies the type of graph:
            %   Graph.BD = Binary Directed
            %   Graph.BU = Binary Undirected
            %   Graph.WD = Weighted Directed
            %   Graph.WU = Weighted Undirected
            %   Graph.WDN = Weighted Directed with Negative weights
            %   Graph.WUN = Weighted Undirected with Negative weights
            %
            % BOOL = IS_BINARY(GRAPH) returns true if GRAPH is a binary
            %   graph, false otherwise.
            
            if isnumeric(arg)  % if graph type as input
                type = arg;
            else  % if graph object as input
                type = arg.get_type();
            end
            
            bool = type==Graph.BD || type==Graph.BU;
        end
        function bool = is_weighted(arg)
            % IS_WEIGHTED checks if the graph type is weighted
            %
            % BOOL = IS_WEIGHTED(TYPE) returns true if TYPE corresponds to
            %   a weighted graph type, false otherwise.
            %   TYPE specifies the type of graph:
            %   Graph.BD = Binary Directed
            %   Graph.BU = Binary Undirected
            %   Graph.WD = Weighted Directed
            %   Graph.WU = Weighted Undirected
            %   Graph.WDN = Weighted Directed with Negative weights
            %   Graph.WUN = Weighted Undirected with Negative weights
            %
            % BOOL = IS_WEIGHTED(GRAPH) returns true if GRAPH is a weighted
            %   graph, false otherwise.
            
            if isnumeric(arg)  % if graph type as input
                type = arg;
            else  % if graph object as input
                type = arg.get_type();
            end
            
            bool = type==Graph.WD || type==Graph.WU || ...
                type==Graph.WUN || type==Graph.WDN;
        end
        function bool = is_positive(arg)
            % IS_POSITIVE checks if the graph type has only non-negative weights
            %
            % BOOL = IS_POSITIVE(TYPE) returns true if TYPE corresponds to
            %   a graph type with only non-negative weights, false otherwise.
            %   TYPE specifies the type of graph:
            %   Graph.BD = Binary Directed
            %   Graph.BU = Binary Undirected
            %   Graph.WD = Weighted Directed
            %   Graph.WU = Weighted Undirected
            %   Graph.WDN = Weighted Directed with Negative weights
            %   Graph.WUN = Weighted Undirected with Negative weights
            %
            % BOOL = IS_POSITIVE(GRAPH) returns true if GRAPH is a graph
            %   with only non-negative weights, false otherwise.
            
            if isnumeric(arg)  % if graph type as input
                type = arg;
            else  % if graph object as input
                type = arg.get_type();
            end
            
            bool = type==Graph.BD || type==Graph.BU || ...
                type==Graph.WU || type==Graph.WD;
        end
        function bool = is_negative(arg)
            % IS_NEGATIVE checks if the graph type has also negative weights
            %
            % BOOL = IS_NEGATIVE(TYPE) returns true if TYPE corresponds to
            %   a graph type tthat can have negative weights, false otherwise.
            %   TYPE specifies the type of graph:
            %   Graph.BD = Binary Directed
            %   Graph.BU = Binary Undirected
            %   Graph.WD = Weighted Directed
            %   Graph.WU = Weighted Undirected
            %   Graph.WDN = Weighted Directed with Negative weights
            %   Graph.WUN = Weighted Undirected with Negative weights
            %
            % BOOL = IS_NEGATIVE(GRAPH) returns true if GRAPH is a graph
            %   that can have negative weights, false otherwise.
            
            if isnumeric(arg)  % if graph type as input
                type = arg;
            else  % if graph object as input
                type = arg.get_type();
            end
            
            bool = type==Graph.WUN || type==Graph.WDN;
        end
    end
    methods (Static,Abstract)
        measurelist(nodal)  % list of measures valid for a graph (no argin = all; true = only nodal; false = only non-nodal)
        measurenumber(nodal)  % number of measures valid for a graph (no argin = all; true = only nodal; false = only non-nodal)
    end
end