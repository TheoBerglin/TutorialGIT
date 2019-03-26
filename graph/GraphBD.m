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
    %   randomize                   -   randomizes the graph
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
        function [gr,R] = randomize(g,bin_swaps,wei_freq)
            % RANDOMIZE randomizes the graph
            %
            % [GR,R] = RANDOMIZE(G) randomizes the graph G and returns the new binary directed
            %   graph GR and the correlation coefficients R, between strength sequences
            %   of input and output connection matrices.
            %
            % Optional parameters that can be passed to the function:
            %   BIN_SWAPS -    average number of swaps of each edge in binary randomization
            %                  (default) bin_swap = 5 : each edge is rewired 5 times
            %   WEI_FREQ  -    frequency of weight sorting in weighted randomization, must
            %                  be in the range of: 0 < wei_freq <= 1
            %                  (default) wei_freq = 1 : older [<2011] versions of MATLAB
            %                  (default) wei_freq = .1 : newer versions of MATLAB
            %
            % Randomization may be better (and execution time will be slower) for
            %   higher values of bin_swaps and wei_freq. Higher values of bin_swaps may
            %   enable a more random binary organization, and higher values of wei_freq
            %   may enable a more accurate conservation of strength sequences.
            %
            % Reference: "Weight-conserving characterization of complex functional brain
            %             networks", M.Rubinov and O.Sporns
            %             "Specificity and Stability in Topology of Protein Networks", S.Maslov
            %             and K.Sneppen
            %
            % See also GraphBD.
            
            W = g.A;
            if ~exist('bin_swaps','var')
                bin_swaps = 5;
            end
            if ~exist('wei_freq','var')
                if nargin('randperm')==1
                    wei_freq = 1;
                else
                    wei_freq = 0.1;
                end
            end
            
            if wei_freq<=0 || wei_freq>1
                error('wei_freq must be in the range of: 0 < wei_freq <= 1.')
            end
            if wei_freq && wei_freq<1 && nargin('randperm')==1
                warning('wei_freq may only equal 1 in older (<2011) versions of MATLAB.')
                wei_freq=1;
            end
            
            n = size(W,1);  % number of nodes
            W(1:n+1:end) = 0;  % clear diagonal
            
            Ap = W>0;  % positive adjacency matrix
            if nnz(Ap) < (n*(n-1))  % if Ap not fully connected
                n2 = size(Ap,1);
                [i2 j2] = find(Ap);
                K2 = length(i2);
                bin_swaps = K2*bin_swaps;
                
                % maximal number of rewiring attempts per 'bin_swaps'
                maxAttempts = round(n2*K2/(n2*(n2-1)));
                % actual number of successful rewirings
                eff = 0;
                
                for bin_swaps=1:bin_swaps
                    att = 0;
                    while (att<=maxAttempts)  % while not rewired
                        while 1
                            e1 = ceil(K2*rand);
                            e2 = ceil(K2*rand);
                            while (e2 == e1),
                                e2 = ceil(K2*rand);
                            end
                            a = i2(e1); b = j2(e1);
                            c = i2(e2); d = j2(e2);
                            
                            if all(a ~= [c d]) && all(b ~= [c d]);
                                break  % all four vertices must be different
                            end
                        end
                        
                        % rewiring condition
                        if ~(Ap(a,d) || Ap(c,b))
                            Ap(a,d) = Ap(a,b); Ap(a,b) = 0;
                            Ap(c,b) = Ap(c,d); Ap(c,d) = 0;
                            
                            j2(e1) = d;  % reassign edge indices
                            j2(e2) = b;
                            eff = eff+1;
                            break;
                        end  % rewiring condition
                        att = att+1;
                    end  % while not rewired
                end  % bin_swapsations
                Ap_r = Ap;
                
            else
                Ap_r = Ap;
            end
            An =~ Ap; An(1:n+1:end) = 0;  % negative adjacency matrix
            An_r =~ Ap_r; An_r(1:n+1:end) = 0;  % randomized negative adjacency
            
            W0 = zeros(n);  % null model network
            for s = [1 -1]
                switch s  % switch sign (positive/negative)
                    case 1
                        Si = sum(W.*Ap,1).';  % positive in-strength
                        So = sum(W.*Ap,2);  % positive out-strength
                        Wv = sort(W(Ap));  % sorted weights vector
                        [I, J] = find(Ap_r);  % weights indices
                        Lij = n*(J-1)+I;  % linear weights indices
                    case -1
                        Si = sum(-W.*An,1).';  % negative in-strength
                        So = sum(-W.*An,2);  % negative out-strength
                        Wv = sort(-W(An));  % sorted weights vector
                        [I, J] = find(An_r);  % weights indices
                        Lij = n*(J-1)+I;  % linear weights indices
                end
                
                P = (So*Si.');  % expected weights matrix
                
                if wei_freq==1
                    for m = numel(Wv):-1:1  % iteratively explore all weights
                        [dum, Oind] = sort(P(Lij));  % get indices of Lij that sort P
                        r = ceil(rand*m);
                        o = Oind(r);  % choose random index of sorted expected weight
                        W0(Lij(o)) = s*Wv(r);  % assign corresponding sorted weight at this index
                        
                        f = 1 - Wv(r)/So(I(o));  % readjust expected weight probabilities for node I(o)
                        P(I(o),:) = P(I(o),:)*f;  % [1 - Wv(r)/S(I(o)) = (S(I(o)) - Wv(r))/S(I(o))]
                        f = 1 - Wv(r)/Si(J(o));  % readjust expected weight probabilities for node J(o)
                        P(:,J(o)) = P(:,J(o))*f;  % [1 - Wv(r)/S(J(o)) = (S(J(o)) - Wv(r))/S(J(o))]
                        
                        So(I(o)) = So(I(o)) - Wv(r);  % readjust in-strength of node I(o)
                        Si(J(o)) = Si(J(o)) - Wv(r);  % readjust out-strength of node J(o)
                        Lij(o) = [];  % remove current index from further consideration
                        I(o) = [];
                        J(o) = [];
                        Wv(r) = [];  % remove current weight from further consideration
                    end
                else
                    wei_period = round(1/wei_freq);  % convert frequency to period
                    for m = numel(Wv):-wei_period:1  % iteratively explore at the given period
                        [dum, Oind] = sort(P(Lij));  % get indices of Lij that sort P
                        R = randperm(m,min(m,wei_period)).';
                        
                        O = Oind(R);  % choose random index of sorted expected weight
                        W0(Lij(O)) = s*Wv(R);  % assign corresponding sorted weight at this index
                        
                        WAi = accumarray(I(O),Wv(R),[n,1]);
                        Iu = any(WAi,2);
                        F = 1 - WAi(Iu)./So(Iu);  % readjust expected weight probabilities for node I(o)
                        P(Iu,:) = P(Iu,:).*F(:,ones(1,n));  % [1 - Wv(r)/S(I(o)) = (S(I(o)) - Wv(r))/S(I(o))]
                        So(Iu) = So(Iu) - WAi(Iu);  % readjust in-strength of node I(o)
                        
                        WAj = accumarray(J(O),Wv(R),[n,1]);
                        Ju = any(WAj,2);
                        F = 1 - WAj(Ju)./Si(Ju);  % readjust expected weight probabilities for node J(o)
                        P(:,Ju) = P(:,Ju).*F(:,ones(1,n)).';  % [1 - Wv(r)/S(J(o)) = (S(J(o)) - Wv(r))/S(J(o))]
                        Si(Ju) = Si(Ju) - WAj(Ju);  % readjust out-strength of node J(o)
                        
                        O = Oind(R);
                        Lij(O) = [];  % remove current index from further consideration
                        I(O) = [];
                        J(O) = [];
                        Wv(R) = [];  % remove current weight from further consideration
                    end
                end
            end
            
            rpos_in = corrcoef(sum( W.*(W>0),1), sum( W0.*(W0>0),1) );
            rpos_ou = corrcoef(sum( W.*(W>0),2), sum( W0.*(W0>0),2) );
            rneg_in = corrcoef(sum(-W.*(W<0),1), sum(-W0.*(W0<0),1) );
            rneg_ou = corrcoef(sum(-W.*(W<0),2), sum(-W0.*(W0<0),2) );
            R = [rpos_in(2) rpos_ou(2) rneg_in(2) rneg_ou(2)];
            
            % Create the new BD graph
            gr = GraphBD(W0);
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