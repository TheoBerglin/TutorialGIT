classdef GraphBD < Graph
    % GraphBD < Graph : Binary directed graph
    %   GraphBD represents a binary directed graph and set of respective measures
    %   that can be calculated on the graph.
    %
    % GraphBD properties (Constant):
    %   MEASURES_BD     -   array of measures defined for binary directed graph
    %
    % GraphBD properties (GetAccess = public, SetAccess = protected):
    %   A               -   connection matrix < Graph
    %   P               -   coefficient p-values < Graph
    %   S               -   community structure < Graph
    %   TYPE            -   graph type < Graph
    %   MS              -   cell array containing the measure structs < Graph
    %   C               -   weighted connection matrix
    %   threshold       -   threshold to be applied for binarization
    %
    % GraphBD properties (Access = protected):
    %   CS       -   a structure for the calculated community structure < Graph
    %   N        -   number of nodes < Graph
    %
    % GraphBD methods (Access = protected):
    %   reset_structure_related_measures  -     resets z-score, participation and modularity < Graph
    %   copyElement         -   copy community structure < Graph
    %
    % GraphBD methods :
    %   GraphBD                     -   constructor
    %   add_measure_to_struct       -   adds measure to MS struct < Graph
    %   get_community_structure     -   returns the community structure < Graph
    %   set_community_structure     -   sets a community structure using the 
    %                                   structure S < Graph
    %   get_type                    -   returns the type of the graph < Graph
    %   get_adjacency_matrix        -   returns the adjacency matrix of the graph < Graph
    %   nodeattack                  -   removes given nodes from a graph < Graph
    %   edgeattack                  -   removes given edges from a graph < Graph
    %   nodenumber                  -   number of nodes in a graph < Graph
    %   calculate_structure_louvain -   calculates a community structure
    %                                   using the louvain algorithm < Graph
    %   calculate_structure_newman  -   calculates a community structure
    %                                   using the newman algorithm < Graph
    %   calculate_structure_fixed   -   calculates a community structure
    %                                   using the fixed algorithm < Graph
    %   calculate_measure           -   calculates a specific measure < Graph
    %   randomize_braph             -   randomize graph using braph algo < Graph
    %   randomize_bct_edit          -   randomize graph using edited bct algo < Graph      
    %
    % GraphBD methods (Static):
    %   measurelist         -   list of measures valid for a binary directed graph
    %   measurenumber       -   number of measures valid for a binary directed graph
    %   positivize          -   positivizes a matrix < Graph
    %   symmetrize          -   symmetrizes a matrix < Graph
    %   binarize            -   binarizes a connection matrix < Graph    
    %   histogram           -   calculates the histogram of a connection matrix < Graph
    %   plotw               -   plots a weighted matrix < Graph
    %   plotb               -   plots a binary matrix < Graph
    %   hist                -   plots the histogram of a connection matrix < Graph
    %   is_nodal            -   checks if measure is nodal < Graph
    %   is_global           -   checks if measure is global < Graph
    %   is_directed         -   checks if the graph type is directed < Graph
    %   is_undirected       -   checks if the graph type is undirected < Graph
    %   is_binary           -   checks if the graph type is binary < Graph
    %   is_weighted         -   checks if the graph type is weighted < Graph
    %   is_positive         -   checks if the graph type has only non-negative weights < Graph
    %   is_negative         -   checks if the graph type has also negative weights < Graph
    %
    % See also Graph, GraphBU, Structure.

    % Version 1:
    %   - Authors: Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
    %   - Date: 2016/01/01
    % Version 2: 
    %   - Authors: Adam Liberda, Theo Berglin, Mite Mijalkov, Ehsan Kakaei & Giovanni Volpe
    %   - Date: 2019/02/25
    
    properties (Constant)
        
        MEASURES_BD = [ ...
            Graph.DEGREE ...
            Graph.DEGREEAV ...
            Graph.IN_DEGREE ...
            Graph.IN_DEGREEAV ...
            Graph.OUT_DEGREE ...
            Graph.OUT_DEGREEAV ...
            Graph.RADIUS ...
            Graph.IN_RADIUS ...
            Graph.OUT_RADIUS ...
            Graph.DIAMETER ...
            Graph.IN_DIAMETER ...
            Graph.OUT_DIAMETER ...
            Graph.ECCENTRICITY ...
            Graph.ECCENTRICITYAV ...
            Graph.IN_ECCENTRICITY ...
            Graph.IN_ECCENTRICITYAV ...
            Graph.OUT_ECCENTRICITY ...
            Graph.OUT_ECCENTRICITYAV ...
            Graph.TRIANGLES ...
            Graph.IN_IN_ASSORTATIVITY ...
            Graph.IN_OUT_ASSORTATIVITY ...
            Graph.OUT_IN_ASSORTATIVITY ...
            Graph.OUT_OUT_ASSORTATIVITY ...
            Graph.PL ...
            Graph.CPL ...
            Graph.PL_WSG ...
            Graph.CPL_WSG ...
            Graph.IN_PL ...
            Graph.IN_CPL ...
            Graph.IN_PL_WSG ...
            Graph.IN_CPL_WSG ...
            Graph.OUT_PL ...
            Graph.OUT_CPL ...
            Graph.OUT_PL_WSG ...
            Graph.OUT_CPL_WSG ...
            Graph.GEFF ...
            Graph.GEFFNODE ...
            Graph.IN_GEFF ...
            Graph.IN_GEFFNODE ...
            Graph.OUT_GEFF ...
            Graph.OUT_GEFFNODE ...
            Graph.LEFF ...
            Graph.LEFFNODE ...
            Graph.CLUSTER ...
            Graph.CLUSTERNODE ...
            Graph.BETWEENNESS ...
            Graph.CLOSENESS ...
            Graph.IN_CLOSENESS ...
            Graph.OUT_CLOSENESS ...
            Graph.CLOSENESS_WSG ...
            Graph.IN_CLOSENESS_WSG ...
            Graph.OUT_CLOSENESS_WSG ...
            Graph.TRANSITIVITY ...
            Graph.MODULARITY ...
            Graph.ZSCORE ...
            Graph.IN_ZSCORE ...
            Graph.OUT_ZSCORE ...
            Graph.PARTICIPATION ...
            Graph.IN_PARTICIPATION ...
            Graph.OUT_PARTICIPATION ...
            Graph.SW ...
            Graph.SW_WSG ...
            Graph.DISTANCE ...
            Graph.DENSITY]
    end
    properties (GetAccess = public, SetAccess = protected)
        C  % weighted correlation matrix
        threshold
    end
    methods
        function g = GraphBD(A,varargin)
            % GRAPHBD(A) creates a binary directed graph with default properties
            %
            % GRAPHBD(A,Property1,Value1,Property2,Value2,...) creates a graph from
            %   any connection matrix A and initializes property Property1 to
            %   Value1, Property2 to Value2, ... .
            %   Admissible properties are:
            %     threshold    -   threshold = 0 (default)
            %     density      -   percent of connections
            %     bins         -   -1:.001:1 (default)
            %     diagonal     -   'exclude' (default) | 'include'
            %     P            -   coefficient p-values
            %     structure    -   community structure object
            %     absolute     -   whether to include negative values from
            %                      the adjacency matrix by taking the
            %                      absolute value, false (default) | true
            %
            % See also Graph, GraphBU.
            
            C = A;
            
            A = Graph.positivize(A,varargin{:});
            [A,threshold] = Graph.binarize(A,varargin{:});  % binarized connection matrix
            
            g = g@Graph(A,varargin{:});
            g.C = C;
            g.threshold = threshold;
            g.TYPE = Graph.BD;
        end
    end
    methods (Static)
        function mlist = measurelist(nodal)
            % MEASURELIST list of measures valid for a binary directed graph
            %
            % MLIST = MEASURELIST(G) returns the list of measures MLIST valid
            %   for a binary directed graph G.
            %
            % MLIST = MEASURELIST(G,NODAL) returns the list of nodal measures MLIST
            %   valid for a binary directed graph G if NODAL is a boolean true and
            %   the list of global measures if NODAL is a boolean false.
            %
            % See also GraphBD.
            
            mlist = GraphBD.MEASURES_BD;
            if exist('nodal','var')
                nbr_of_ms = length(Graph.MEASURES);
                nodal_idx = zeros(1, nbr_of_ms);
                for i=1:nbr_of_ms
                    nodal_idx(i) = eval(sprintf('Graph.%s_NODAL', Graph.MEASURES{i}));
                end
                nodal_ms = find(nodal_idx);  % find measure id (index)
                if nodal
                    mlist = intersect(mlist, nodal_ms);
                else
                    mlist = setdiff(mlist, nodal_ms);
                end
            end
        end
        function n = measurenumber(varargin)
            % MEASURENUMBER number of measures valid for a binary directed graph
            %
            % N = MEASURENUMBER(G) returns the number of measures N valid for a
            %   binary directed graph G.
            %
            % N = MEASURELIST(G,NODAL) returns the number of nodal measures N
            %   valid for a binary directed graph G if NODAL is a boolean true and
            %   the number of global measures if NODAL is a boolean false.
            %
            % See also GraphBD, measurelist.
            
            mlist = GraphBD.measurelist(varargin{:});
            n = numel(mlist);
        end
    end
end