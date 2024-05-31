
@doc " A module encorporating functionalities for the branching structures."
module DendriticBranches 
    export subset, is_contiguous_subset, find_first_target_symbols
    using Combinatorics
    using StatsBase
    using .Iterators
    using IterTools
    
    
    # EXPORTED MAIN FUNCTIONS  -----------------------------------------------------------------------------------------
    
    """
        is_subset(target::Union{Symbol, Vector}, sequence::Vector{Symbol})
    
    Check if `target` is a subset of `sequence`.
    
    # Arguments
    - `target`: The target sequence.
    - `sequence`: The sequence. 
    
    # Returns
    A boolean value indicating whether `target` is a subset of `sequence`.
    
    # Example 
    ```jldoctest
    julia> is_subset([:A, :B, :C], [:B, :C, :A, :B, :A]
    True 
    
    julia> is_subset([:A, :B, :C], [:B, :A, :A, :B, :A]
    False
    ```
    ---------------------------------------------------------------------------
    #
    """
    function is_subset(target::Union{Symbol, Vector}, sequence::Vector{Symbol}) 
    
        # SINGLE SYMBOL 
        if isa(target, Symbol)
            return issubset([target], sequence)
        
        # FLAT LIST 
        elseif is_flat_list(target)
            return issubset(target, sequence)
    
        # OR CONDITION 
        elseif target[1][1] == :|| 
            result = target[2]
            symbols = target[1][2:end] 
            if !is_flat_list(symbols)
                boolean = any(x -> is_subset(x, sequence), symbols)  
            else 
                return OR(result, symbols, sequence)
            end 
        
        # AND CONDITION 
        elseif target[1][1] == :& 
            result = target[2]
            symbols = target[1][2:end] 
            if !is_flat_list(symbols)
                boolean = all(x -> is_subset(x, sequence), symbols)        
            else 
                return AND(result, symbols, sequence)
            end 
        end 
    
        return boolean && issubset([result], sequence)
    end 
    
    
    
    """
        branching_combinations(target::Union{Symbol, Vector})
    
    Generates all possible combinations for a given branching pattern.
    
    # Arguments
    - `target`: The target branching pattern.
    
    # Returns
    A list of all possible combinations.
    
    # Examples 
    ```jldoctest
    julia> branching_combinations([ [:||, :A, :B], :C ])
    [[:A, :B, :C], [:B, :A, :C], [:A, :C], [:B, :C]]

    julia> branching_combinations([ [:&, :A, :B], :C ])
    [[:A, :B, :C], [:B, :A, :C]]

    julia> branching_combinations([:A, :B, :A])
    [:A, :B, :A]
    
    julia> branching_combinations([ [:&, [ [:||, :A, :B], :C], :D], :E])
    [[:A, :B, :C, :D, :E], [:B, :A, :C, :D, :E], [:A, :C, :D, :E], [:B, :C, :D, :E], [:D, :A, :B, :C, :E], [:D, :B, :A, :C, :E], [:D, :A, :C, :E], [:D, :B, :C, :E]]

    
    ```
    ---------------------------------------------------------------------------
    #
    """
    function branching_combinations(target::Union{Symbol, Vector}) 
    
        # SINGLE SYMBOL 
        if isa(target, Symbol)
            return [target]
        
        # FLAT LIST 
        elseif is_flat_list(target)
            return target
    
        # OR CONDITION 
        elseif target[1][1] == :|| 
            result = target[2]
            symbols = target[1][2:end] 
            if !is_flat_list(symbols)
                combination_list = combines_or([branching_combinations(t) for t in symbols])
            else 
                return get_or_combinations(symbols, result)
            end 
        
        # AND CONDITION 
        elseif target[1][1] == :& 
            result = target[2]
            symbols = target[1][2:end] 
            if !is_flat_list(symbols)
                combination_list = combines_and([branching_combinations(t) for t in symbols])  
            else 
                return get_and_combinations(symbols, result)
            end 
        end 
    
        return final_output(result, combination_list)
    end 
    
    
    """
        is_contiguous_subset(subseq::Vector{Symbol}, seq::Vector{Symbol})
    Checks whether `subseq` occurs in `seq` in identical order.
    
    # Arguments
    
    - `subseq`: The subsequence that is searched in `seq`.
    - `seq`: The sequence in which `subseq` is searched.
    
    # Returns
    A boolean indicating whether `subseq` occurs in identical order within `seq`.
    
    # Examples 
    ```jldoctest
    julia> is_contiguous_subset([:A, :B, :B], [:B, :C, :A, :B, :B, :A, :C])
    True 
    
    julia> is_contiguous_subset([:A, :B, :C], [:B, :A, :B, :A, :C, :B, :C])
    False 
    ```
    ---------------------------------------------------------------------------
    #
    """
    function is_contiguous_subset(subseq::Vector{Symbol}, seq::Vector{Symbol})
        len_subseq = length(subseq)
        len_seq = length(seq)
    
        # Loop through the sequence to find a contiguous match
        for i in 1:(len_seq - len_subseq + 1)
            if seq[i:i+len_subseq-1] == subseq
                return true
            end
        end
    
        return false
    end
    
    
    """
        is_contiguous_subset(branching::Vector{Any}, seq::Vector{Symbol})
    
    Checks whether any combination of `branching` occurs in `seq` in identical order.
    
    # Arguments
    
    - `branching`: A branching construct.
    - `seq`: The sequence in which `subseq` is searched.
    
    # Returns
    A boolean indicating whether any combination of `branching` occurs in identical order within `seq`.
    
    # Examples 
    ```jldoctest
    julia> is_contiguous_subset([ [:||, [ [:&, :A, :B], :C], :D], :E], [:B, :B, :A, :C, :E, :A, :E, :C] )
    True 
    
    julia> is_contiguous_subset([ [:||, [ [:&, :A, :B], :C], :D], :E], [:C, :A, :D, :E] )
    True 
    
    julia> is_contiguous_subset([ [:||, [ [:&, :A, :B], :C], :D], :E], [:A, :C, :D, :A, :B, :C, :C, :B, :E] )
    False
    
    julia> is_contiguous_subset([ [:||, [ [:&, :A, :B], :C], :D], :E], [:E, :A, :D, :A, :C])
    False 
    ```
    ---------------------------------------------------------------------------
    #
    """
    function is_contiguous_subset(branching::Vector{Any}, seq::Vector{Symbol})
        combinations = branching_combinations(branching)
        return any(x->is_contiguous_subset(x, seq), is_flat_list(combinations) ? [combinations] : combinations) 
    end 
    
    
    """
        find_first_target_symbols(seq::Vector{Symbol}, subseq::Vector{Symbol})
    
    Retrieve the initial indices of each Symbol in subseq where the Symbols appear in the same order, with the possibility of other symbols occurring in between.
    
    # Arguments
    
    - `subseq`: The indices of these elements are searched in `seq`.
    - `seq`: The sequence in which symbol indices of `subseq` are searched.
    
    # Returns
    A list with initial indices of each Symbol in subseq where the Symbols appear in the same order, with the possibility of other symbols occurring in between. 
    If the Symbols are not occuring in the `seq` or not in the correct order, `nothing` is returned.
    
    # Examples 
    ```jldoctest
    julia> find_first_target_symbols([:B, :B, :A, :C, :E, :A, :E, :C], [:B, :A, :C])
    [1, 3, 4]
    
    julia> find_first_target_symbols([:B, :B, :A, :C, :E, :A, :E, :C], [:H, :F, :G])
    nothing 
    
    julia> find_first_target_symbols([:B, :B, :A, :C, :E, :A, :E, :C], [:A, :G, :F])
    nothing 
    
    julia> find_first_target_symbols([:B, :B, :A, :C, :E, :A, :A, :C], [:A, :A, :A])
    [3, 6, 7]
    ```
    ---------------------------------------------------------------------------
    #
    """
    function find_first_target_symbols(seq::Vector{Symbol} , subseq::Vector{Symbol})
        indices = Int64[]
        len_seq = length(seq)
        max_value = 0
        for i in 1:length(subseq)
            if !isempty(indices)
                max_value , _ = findmax(indices)
            end
            index = findfirst(symbol -> symbol == subseq[i],seq[max_value + 1:len_seq])
            if index != nothing
                push!(indices,max_value + findfirst(symbol -> symbol == subseq[i],seq[max_value + 1:len_seq]))
            else
                return nothing
            end
        end
        return indices
    end
    
    
    """
        find_first_target_symbols(seq::Vector{Symbol}, branching::Vector{Any})
    
    For subsequence in `branching` apply `find_first_target_symbols(seq::Vector{Symbol}, subseq::Vector{Symbol})`.
    
    # Arguments
    
    - `branching`: A list of subsequences.
    - `seq`: The sequence in which symbol indices of `subseq` are searched.
    
    # Returns
    A list containing all indices lists for all combinations of the branching pattern.
    
    # Examples 
    ```jldoctest
    ## first target symbols for possible branchings [[:A, :C], [:B, :C]]
    julia> find_first_target_symbols([:B, :B, :A, :C, :E, :A, :E, :C], [ [:||, :A, :B], :C ])
    [[1, 3, 4], [3, 4], [1, 4]]
    
    julia> find_first_target_symbols([:C, :B, :B, :C, :A], [ [:||, :A, :B], :C ])
    [nothing, nothing, nothing, [2, 4]]
    
    julia> find_first_target_symbols([:C, :B, :B, :A, :A], [ [:||, :A, :B], :C ])
    [nothing, nothing, nothing, nothing]
    ```
    ---------------------------------------------------------------------------
    #
    """
    function find_first_target_symbols(seq::Vector{Symbol}, branching::Vector{Any})
        combinations = branching_combinations(branching)
        combinations = is_flat_list(combinations) ? [combinations] : combinations
        return [find_first_target_symbols(seq, c) for c in combinations]
    end 
    
    # -----------------------------------------------------------------------------------------------------------
    
    
    # HELPER FUNCTIONS  -----------------------------------------------------------------------------------------
    
    is_flat_list(lst::Vector) = all(x -> !(x isa Vector), lst) 
    is_vector_list = x -> all(elt -> isa(elt, Vector), x) 
    
    
    """
        get_and_combinations(symbols::Vector{Symbol}, result::Symbol, count=length(symbols))
    
    Generates all AND combinations based on `symbols` and `result`.
    
    # Arguments
    
    - `result`: The final symbol that follows if the condition of the symbols is given.
    - `symbols`: A list of symbols.
    - `count`: Integer denoting the length of the vector `symbols`.
    
    # Returns
    All AND combinations based on `symbols` and `result`.
    
    # Examples 
    ```jldoctest
    julia> get_and_combinations([:A, :B], :E)
    [[:A, :B, :E], [:B, :A, :E]]
    
    ```
    ---------------------------------------------------------------------------
    #
    """
    function get_and_combinations(symbols::Vector{Symbol}, result::Symbol, count=length(symbols))
        return [push!(perm, result) for perm in collect(Combinatorics.permutations(symbols, count))]
    end 
    
    
    
    """
        OR(result::Symbol, symbols::Vector, sequence::Vector{Symbol})
    
    Processes the OR operation for a given construct.
    
    # Arguments
    
    - `result`: The final symbol that follows if the condition of the symbols is given.
    - `symbols`: A list of symbols.
    - `sequence`: The sequence on which to apply the function.
    
    # Returns
    A boolean indicating whether at least one of the symbols and the result are a subset of the sequence.
    
    # Examples 
    ```jldoctest
    julia> OR(:C, [:A, :B], [:A, :C, :B, :A, :C])
    True 
    
    julia> OR(:C, [:A, :B], [:A, :A, :B, :A, :B])
    False
    
    ```
    ---------------------------------------------------------------------------
    #
    """
    function OR(result::Symbol, symbols::Vector, sequence::Vector{Symbol})
        return any(x -> all(y -> y in sequence, x), [[e] for e in symbols]) && issubset([result], sequence)
    end
    
    
    """
        AND(result, symbols, sequence)
    
    Processes the AND operation for a given construct.
    
    # Arguments
    
    - `result`: The final symbol that follows if the condition of the symbols is given.
    - `symbols`: A list of symbols.
    - `sequence`: The sequence on which to apply the function.
    
    # Returns
    A boolean indicating whether all symbols and the result are a subset of the sequence.
    
    # Examples 
    ```jldoctest
    julia> AND(:C, [:A, :B], [:A, :A, :B, :C, :A, :B])
    True 
    
    julia> AND(:C, [:A, :B], [:A, :A, :B, :B, :A, :B])
    False 
    
    julia> AND(:C, [:A, :B], [:A, :C, :A, :C, :C])
    False 
    
    ```
    ---------------------------------------------------------------------------
    #
    """
    function AND(result::Symbol, symbols::Vector, sequence::Vector{Symbol})
        return all(x -> all(y -> y in sequence, x), [[e] for e in symbols]) && issubset([result], sequence)
    end  
    
    
    """
        get_or_combinations(symbols::Vector{Symbol}, result::Symbol, count=1)
    
    Creates all OR combinations based on `symbols` and `result`.
    
    # Arguments
    
    - `result`: The final symbol that follows if the condition of the symbols is given.
    - `symbols`: A list of symbols.
    - `count`: The amount of elements that are part of the combination.
    
    # Returns
    A list with all OR combinations.
    
    # Examples 
    ```jldoctest
    julia> get_or_combinations([:A, :B], :C)
    [[:A, :B, :C], [:B, :A, :C], [:A, :C], [:B, :C]]

    
    ```
    ---------------------------------------------------------------------------
    #
    """
    function get_or_combinations(symbols::Vector{Symbol}, result::Symbol, count=1)
        return append!(get_and_combinations(symbols, result), [push!(perm, result) for perm in collect(Combinatorics.permutations(symbols, count))])
    end 
    
    
    """
        final_output(result::Symbol, combination_list::Vector)
    
    Adds the final symbol to the combination_list. 
    
    # Arguments
    - `result`: The final symbol of the target.
    - `combination_list` : List with all combinations. 
    
    # Returns
    The combination_list added with the final symbol.
    
    # Examples 
    ```jldoctest
    julia> final_output(:C, [:A, :B])
    [[:A, :B, :C]]
    
    julia> final_output(:E, [[:A, :C, :D], [:B, :C, :D]])
    [[:A, :C, :D, :E], [:B, :C, :D, :E]]
    
    ```
    ---------------------------------------------------------------------------
    #
    """
    function final_output(result::Symbol, combination_list::Vector)
        if is_vector_list(combination_list)
            return[push!(c, result) for c in deepcopy(combination_list)]
        elseif is_flat_list(combination_list)
            push!(combination_list, result)
            return [combination_list]
        end 
    end 
    
    
    """
        combines_or(expression::Vector) 
    
    Combines all branchings in `symbols` based on the OR operation.
    
    # Arguments
    - `symbols`: A given branching pattern.
    
    # Returns
    The combined OR list. 
    
    # Examples 
    ```jldoctest
    julia> combines_or([[[:A, :C], [:B, :C]], [:D]])
    [[:A, :C], [:B, :C], [:D], [:A, :C, :D], [:B, :C, :D], [:D, :A, :C], [:D, :B, :C]]

    julia> combines_or([[[:A], [:B]], [[:C], [:D]]])
    [[:A], [:B], [:C], [:D], [:A, :C], [:B, :C], [:A, :D], [:B, :D], [:C, :A], [:D, :A], [:C, :B], [:D, :B]]
    
    ```
    ---------------------------------------------------------------------------
    #
    """
    function combines_or(expression::Vector) 
        if all(x -> is_flat_list(x), expression)
            return append!(expression,[collect(Iterators.flatten(c)) for c in collect(Combinatorics.permutations(expression, length(expression)))])
        else
            return append!(collect(Iterators.flatten([is_vector_list(e)  ? e : [e] for e in expression])), combines_and(expression))
        end   
    end
    
    
    """
        combines_and(symbols::Vector)
    
    Combines all branchings in `symbols` based on the AND operation.
    
    # Arguments
    - `symbols`: The target branching pattern.
    
    # Returns
    The combined AND list. 
    
    # Examples 
    ```jldoctest
    julia> combines_and([[[:A, :C], [:B, :C]], [:D]])
    [[:A, :C, :D], [:B, :C, :D], [:D, :A, :C], [:D, :B, :C]]
    
    julia> combines_and([[[:A, :E], [:B, :E]], [[:D, :F], [:C, :F]]])
    [[:A, :E, :D, :F], [:B, :E, :D, :F], [:A, :E, :C, :F], [:B, :E, :C, :F], [:D, :F, :A, :E], [:C, :F, :A, :E], [:D, :F, :B, :E], [:C, :F, :B, :E]]
    ```
    ---------------------------------------------------------------------------
    #
    """
    function combines_and(symbols::Vector)
        if any(x->is_vector_list(x), symbols)
            return [vcat(tuple...) for combinations in collect(Combinatorics.permutations(symbols, length(symbols))) for tuple in IterTools.product([is_vector_list(c) ? c : [c] for c in combinations]...)]
        elseif all(x->is_flat_list(x), symbols)
            return collect(flatten(symbols))
        end 
    end 
    
    # ----------------------------------------------------------------------------------------------------------
    
    
end 


