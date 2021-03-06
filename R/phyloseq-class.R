################################################################################
#' Build phyloseq-class objects from their components.
#'
#' \code{phyloseq()} is a constructor method, This is the main method
#' suggested for constructing an experiment-level (\code{\link{phyloseq-class}})
#' object from its component data 
#' (component data classes: \code{\link{otu_table-class}}, \code{\link{sample_data-class}}, 
#'  \code{\link{taxonomyTable-class}}, \code{\link{phylo-class}}).
#'
#' @usage phyloseq(...)
#'
#' @param ... One or more component objects among the set of classes
#'  defined by the phyloseq package, as well as \code{phylo}-class
#'  (defined by the \code{\link{ape-package}}). Each argument should be a different class.
#'  For combining multiple components of the same class, or multiple phyloseq-class
#'  objects, use the \code{\link{merge_phyloseq}} function. Unlike in earlier
#'  versions, the arguments to phyloseq do not need to be named, and the order
#'  of the arguments does not matter.
#'
#' @return The class of the returned object depends on the argument 
#'  class(es). For an experiment-level object, two or more component data objects
#'  must be provided.
#'  Otherwise, if a single component-class
#'  is provided, it is simply returned as-is. 
#'  The order of arguments does not matter. 
#'
#' @seealso \code{\link{merge_phyloseq}}
#' @export
#' @examples
#' data(esophagus)
#' x1 = phyloseq(otu_table(esophagus), phy_tree(esophagus))
#' identical(x1, esophagus)
#' # # data(GlobalPatterns)
#' # # GP <- GlobalPatterns
#' # # phyloseq(sample_data(GP), otu_table(GP))
#' # # phyloseq(otu_table(GP), phy_tree(GP))
#' # # phyloseq(tax_table(GP), otu_table(GP))
#' # # phyloseq(phy_tree(GP), otu_table(GP), sample_data(GP))
#' # # phyloseq(otu_table(GP), tax_table(GP), sample_data(GP))
#' # # phyloseq(otu_table(GP), phy_tree(GP), tax_table(GP), sample_data(GP))
phyloseq <- function(...){
	
	arglist <- list(...)
	
	# Remove names from arglist. Will replace them based on their class
	names(arglist) <- NULL

	# ignore all but component data classes.
	arglist  <- arglist[sapply(arglist, is.component.class)]
	
	# Make the name-replaced, splatted list
	splatlist <- sapply(arglist, splat.phyloseq.objects)

	# rm any forbidden chars in index names (e.g. quotes - phylogenetic tree).
	# Right now, only extra quotes are forbidden.
	splatlist = lapply(splatlist, function(x){
		taxa_names(x) <- gsub("\"", "", taxa_names(x), fixed=TRUE)
		taxa_names(x) <- gsub("\'", "", taxa_names(x), fixed=TRUE)
		return(x)
	})
	
	####################
	## Need to determine whether to
	# (A) instantiate a new raw/uncleaned phyloseq object, or
	# (B) return a single component, or
	# (C) to stop with an error because of incorrect argument types.
	if( length(splatlist) > length(get.component.classes()) ){
		stop("Too many components provided\n")
	} else if( length(names(splatlist)) > length(unique(names(splatlist))) ){
		stop("Only one of each component type allowed.\n",
		"For merging multiple objects of the same type/class, try merge_phyloseq(...)\n")
	} else if( length(splatlist) == 1){
		return(arglist[[1]])
	} else {
		# Instantiate the phyloseq-class object, ps.
		ps <- do.call("new", c(list(Class="phyloseq"), splatlist) )
	}

	####################
	## Reconcile the taxa and sample index names between components
	## in the newly-minted phyloseq object
	shared_taxa    = intersect_taxa(ps)
	shared_samples = intersect_samples(ps) 
	
	if( length(shared_taxa) < 1 ){
		stop("Problem with OTU/taxa indices among those you provided.\n",
			"Check using intersect() and taxa_names()\n"
		)
	}	
	if( length(shared_samples) < 1 ){
		stop("Problem with sample indices among those you provided.\n",
				 "Check using intersect() and taxa_names()\n"
		)
	}
		
	# Start with OTU indices
	ps = prune_taxa(shared_taxa, ps)
	
	# Verify there is more than one component 
	# that describes samples before attempting to reconcile.
	ps = prune_samples(shared_samples, ps)
	
	# Force both samples and taxa indices to be in the same order.
	ps = index_reorder(ps, "both")
	
	return(ps)
}
################################################################################
# A relatively fast way to access from phyloseq object components
# f - function name as character string
# physeq - a phyloseq object (phyloseq-class instance)
#' @keywords internal
f_comp_ps = function(f, physeq){
	sapply(names(getSlots("phyloseq")), function(i, ps){
		eval(parse(text=paste(f, "(ps@", i, ")", sep="")))
	}, physeq)
}
# f_comp_ps("taxa_names", ps)
# f_comp_ps("ntaxa", ps)
# Reduce("union", f_comp_ps("taxa_names", ps))
# Reduce("intersect", f_comp_ps("taxa_names", ps))
################################################################################
#' Show the component objects classes and slot names.
#'
#' There are no arguments to this function. It returns a named character
#' when called, which can then be used for tests of component data types, etc.
#'
#' @usage get.component.classes()
#' 
#' @return a character vector of the component objects classes, where each 
#' element is named by the corresponding slot name in the phyloseq-class.
#'
#' @keywords internal
#'
#' @examples #
#' #get.component.classes()
get.component.classes <- function(){
	# define classes vector
	component.classes <- c("otu_table", "sample_data", "phylo", "taxonomyTable", "XStringSet")
	# the names of component.classes needs to be the slot names to match getSlots / splat
	names(component.classes) <- c("otu_table", "sam_data", "phy_tree", "tax_table", "refseq")	
	return(component.classes)
}
# Explicitly define components/slots that describe taxa.
#' @keywords internal
taxa.components = function(){
	# define classes vector
	component.classes <- c("otu_table", "phylo", "taxonomyTable", "XStringSet")
	# the names of component.classes needs to be the slot names to match getSlots / splat
	names(component.classes) <- c("otu_table", "phy_tree", "tax_table", "refseq")	
	return(component.classes)
}
# Explicitly define components/slots that describe samples.
#' @keywords internal
sample.components = function(){
	# define classes vector
	component.classes <- c("otu_table", "sample_data")
	# the names of component.classes needs to be the slot names to match getSlots / splat
	names(component.classes) <- c("otu_table", "sam_data")
	return(component.classes)
}
# Returns TRUE if x is a component class, FALSE otherwise.
# This shows up over and over again in data infrastructure
#' @keywords internal
is.component.class = function(x){
	inherits(x, get.component.classes())
}
################################################################################
#' Convert \code{\link{phyloseq-class}} into a named list of its non-empty components.
#'
#' This is used in internal handling functions, and one of its key features
#' is that the names in the returned-list match the slot-names, which is useful
#' for constructing calls with language-computing functions like \code{\link{do.call}}.
#' Another useful aspect is that it only returns the contents of non-empty slots.
#' In general, this should only be used by phyloseq-package developers. Standard
#' users should not need or use this function, and should use the accessors and 
#' other tools that leave the multi-component object in one piece.
#'
#' @usage splat.phyloseq.objects(x)
#'
#' @param x A \code{\link{phyloseq-class}} object. Alternatively, a component
#'  data object will work, resulting in named list of length 1. 
#' 
#' @return A named list, where each element is a component object that was contained 
#' in the argument, \code{x}. Each element is named according to its slot-name in
#' the phyloseq-object from which it is derived. 
#' If \code{x} is already a component data object,
#' then a list of length (1) is returned, also named.
#'
#' @seealso merge_phyloseq
#' @keywords internal
#' @examples #
splat.phyloseq.objects <- function(x){
	if( is.component.class(x) ){
	# Check if class of x is among the component classes already (not phyloseq-class)		
		splatx <- list(x)
		names(splatx) <- names(which(sapply(get.component.classes(), function(cclass, x) inherits(x, cclass), x)))
	} else if( inherits(x, "phyloseq") ){
	# Else, check if it inherits from phyloseq, and if-so splat
		slotnames = names(getSlots("phyloseq"))
		allslots  = sapply(slotnames, function(i, x){access(x, i, FALSE)}, x)
		splatx    = allslots[!sapply(allslots, is.null)]
	} else {
	# Otherwise, who knows what it is, silently return NULL.
		return(NULL)
	}
	return(splatx)
}
################################################################################
#' Return the non-empty slot names of a phyloseq object.
#'
#' Like \code{\link{getSlots}}, but returns the class name if argument 
#' is component data object.
#' 
#' @usage getslots.phyloseq(physeq)
#'
#' @param physeq A \code{\link{phyloseq-class}} object. If \code{physeq} is a component
#'  data class, then just returns the class of \code{physeq}.
#' 
#' @return identical to getSlots. A named character vector of the slot classes
#' of a particular S4 class, where each element is named by the slot name it
#' represents. If \code{physeq} is a component data object,
#' then a vector of length (1) is returned, named according to its slot name in
#' the \code{\link{phyloseq-class}}.
#' 
#' @seealso merge_phyloseq
#' @export
#' @examples #
#'  data(GlobalPatterns)
#'  getslots.phyloseq(GlobalPatterns)
#'  data(esophagus)
#'  getslots.phyloseq(esophagus)
getslots.phyloseq = function(physeq){
	names(splat.phyloseq.objects(physeq))
}
################################################################################
#' Universal slot accessor function for phyloseq-class.
#'
#' This function is used internally by many accessors and in 
#' many functions/methods that need to access a particular type of component data.
#' If something is wrong, or the slot is missing, the expected behavior is that
#' this function will return NULL. Thus, the output can be tested by 
#' \code{\link{is.null}} as verification of the presence of a particular 
#' data component. Unlike the component-specific accessors (e.g. \code{\link{otu_table}},
#' or \code{\link{phy_tree}}),
#' the default behavior is not to stop with an error if the desired slot is empty.
#' In all cases this is controlled by the \code{errorIfNULL} argument, which can
#' be set to \code{TRUE} if an error is desired. 
#'
#' @usage access(physeq, slot, errorIfNULL=FALSE)
#'
#' @param physeq (Required). \code{\link{phyloseq-class}}.
#'
#' @param slot (Required). A character string indicating the slot (not data class)
#'  of the component data type that is desired.
#'
#' @param errorIfNULL (Optional). Logical. Should the accessor stop with 
#'  an error if the slot is empty (\code{NULL})? Default \code{FALSE}. 
#'
#' @return Returns the component object specified by the argument \code{slot}. 
#'  Returns NULL if slot does not exist. Returns \code{physeq} as-is 
#'  if it is a component class that already matches the slot name.
#'
#' @seealso \code{\link{getslots.phyloseq}}, \code{\link{merge_phyloseq}}
#' @export
#' @examples #
#' ## data(GlobalPatterns)
#' ## access(GlobalPatterns, "tax_table")
#' ## access(GlobalPatterns, "phy_tree")
#' ## access(otu_table(GlobalPatterns), "otu_table")
#' ## # Should return NULL:
#' ## access(otu_table(GlobalPatterns), "sample_data")
#' ## access(otuTree(GlobalPatterns), "sample_data")
#' ## access(otuSam(GlobalPatterns), "phy_tree")
access <- function(physeq, slot, errorIfNULL=FALSE){
	if( is.component.class(physeq) ){
		# If physeq is a component class, might return as-is. Depends on slot.
		if( inherits(physeq, get.component.classes()[slot]) ){
			# if slot-name matches, return physeq as-is.
			out = physeq
		} else {
			# If slot/component mismatch, set out to NULL. Test later if this is an error.			
			out = NULL
		}
	} else if(!slot %in% slotNames(physeq) ){
		# If slot is invalid, set out to NULL. Test later if this is an error.
		out = NULL
	} else {
		# By elimination, must be valid. Access slot
		out = eval(parse(text=paste("physeq@", slot, sep=""))) 
	}
	if( errorIfNULL & is.null(out) ){
		# Only error regarding a NULL return value if errorIfNULL is TRUE.
		stop(slot, " slot is empty.")
	}
	return(out)
}
################################################################################
#' Returns the intersection of species and samples for the components of x
#'
#' This function is used internally as part of the infrastructure to ensure that
#' component data types in a phyloseq-object have exactly the same taxa/species.
#' It relies heavily on the \code{\link{Reduce}} function to determine the 
#' strictly common species.
#'
#' @usage intersect_taxa(x)
#'
#' @param x (Required). A \code{\link{phyloseq-class}} object
#'  that contains 2 or more components
#'  that in-turn describe species/taxa.
#'
#' @return Returns a character vector of only those species that are present in
#'  all species-describing components of \code{x}.
#'
#' @seealso \code{\link{Reduce}}, \code{\link{intersect}}
#' @keywords internal
#' @examples #
#' ## data(GlobalPatterns)
#' ## head(intersect_taxa(GlobalPatterns), 10)
intersect_taxa <- function(x){
	taxa_vectors = f_comp_ps("taxa_names", x)
	taxa_vectors = taxa_vectors[!sapply(taxa_vectors, is.null)]
	return( Reduce("intersect", taxa_vectors) )
}
#' @keywords internal
intersect_samples <- function(x){
	sample_vectors = f_comp_ps("sample_names", x)
	sample_vectors = sample_vectors[!sapply(sample_vectors, is.null)]
	return( Reduce("intersect", sample_vectors) )
}
################################################################################
#' Force index order of phyloseq objects
#'
#' @usage index_reorder(ps, index_type)
#'
#' @param ps (Required). A \code{\link{phyloseq-class}} instance.
#' @param index_type (Optional). A character string
#'  specifying the indices to properly order.
#'  Supported values are \code{c("both", "taxa", "samples")}.
#'  Default is \code{"both"}, meaning samples and taxa indices
#'  will be checked/re-ordered.
#'
#' @keywords internal
#' @docType methods
#'
#' @examples
#' ## data("GlobalPatterns")
#' ## GP = index_reorder(GlobalPatterns)
setGeneric("index_reorder", function(ps, index_type) standardGeneric("index_reorder") )
#' @rdname index_reorder
#' @aliases index_reorder,phyloseq-method
setMethod("index_reorder", "phyloseq", function(ps, index_type="both"){
	if( index_type %in% c("both", "taxa") ){
		## ENFORCE CONSISTENT ORDER OF TAXA INDICES.
		if( !is.null(phy_tree(ps, FALSE)) ){
			# If there is a phylogenetic tree included, 
			# re-order based on that, and reorder the otu_table
			# The new taxa order, torder, will also trickle down to
			# the taxonomyTable or XStringSet if present.
			torder = taxa_names(phy_tree(ps))
			# Re-order the OTU table
			if( taxa_are_rows(ps) ){
				ps@otu_table = otu_table(ps)[torder, ]
			} else {
				ps@otu_table = otu_table(ps)[, torder]
			}
		} else {
			# Else, re-order anything/everything else based on the OTU-table order
			torder = taxa_names(otu_table(ps))
		}
		if( !is.null(tax_table(ps, FALSE)) ){
			# If there is a taxonomyTable, re-order that too.
			ps@tax_table = tax_table(ps)[torder, ]
		}
		if( !is.null(refseq(ps, FALSE)) ){
			# If there is a XStringSet, re-order that too.
			ps@refseq = refseq(ps)[torder]
		}		
	}
	
	if( index_type %in% c("both", "samples") ){
		## ENFORCE CONSISTENT ORDER OF SAMPLE INDICES
		# Errors can creep when sample indices do not match.
		if( !is.null(sample_data(ps, FALSE)) ){
			# check first that ps has sample_data
			if( !all(sample_names(otu_table(ps)) == rownames(sample_data(ps))) ){
				# Reorder the sample_data rows so that they match the otu_table order.
				ps@sam_data <- sample_data(ps)[sample_names(otu_table(ps)), ]
			}		
		}
	}
	
	return(ps)
})
################################################################################