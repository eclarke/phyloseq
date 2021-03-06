\name{plot_tree}
\alias{plot_tree}
\title{Plot a phylogenetic tree with optional annotations}
\usage{
  plot_tree(physeq, method="sampledodge", nodelabf=NULL,
  color=NULL, shape=NULL, size=NULL, min.abundance=Inf,
  label.tips=NULL, text.size=NULL, sizebase=5,
  base.spacing=0.02, ladderize=FALSE, plot.margin=0.2,
  title=NULL)
}
\arguments{
  \item{physeq}{(Required). The data about which you want
  to plot and annotate a phylogenetic tree, in the form of
  a single instance of the \code{\link{phyloseq-class}},
  containing at minimum a phylogenetic tree component (try
  \code{\link{phy_tree}}). One of the major advantages of
  this function over basic tree-plotting utilities in the
  \code{\link{ape}}-package is the ability to easily
  annotate the tree with sample variables and taxonomic
  information. For these uses, the \code{physeq} argument
  should also have a \code{\link{sample_data}} and/or
  \code{\link{tax_table}} component(s).}

  \item{method}{(Optional). Character string. Default
  \code{"sampledodge"}. The name of the annotation method
  to use. This will be expanded in future versions.
  Currently only \code{"sampledodge"} and \code{"treeonly"}
  are supported. The \code{"sampledodge"} option results in
  points drawn next to leaves if individuals from that taxa
  were observed, and a separate point is drawn for each
  sample.}

  \item{nodelabf}{(Optional). A function. Default
  \code{NULL}. If \code{NULL}, the default, a function will
  be selected for you based upon whether or not there are
  node labels in \code{phy_tree(physeq)}. For convenience,
  the phyloseq package includes two generator functions for
  adding arbitrary node labels (can be any character
  string), \code{\link{nodeplotdefault}}; as well as for
  adding bootstrap values in a certain range,
  \code{\link{nodeplotboot}}. To not have any node labels
  in the graphic, set this argument to
  \code{\link{nodeplotblank}}.}

  \item{color}{(Optional). Character string. Default
  \code{NULL}. The name of the variable in \code{physeq} to
  map to point color.}

  \item{shape}{(Optional). Character string. Default
  \code{NULL}. The name of the variable in \code{physeq} to
  map to point shape.}

  \item{size}{(Optional). Character string. Default
  \code{NULL}. The name of the variable in \code{physeq} to
  map to point size. A special argument \code{"abundance"}
  is reserved here and scales point size using abundance in
  each sample on a log scale.}

  \item{min.abundance}{(Optional). Numeric. The minimum
  number of individuals required to label a point with the
  precise number. Default is \code{Inf}, meaning that no
  points will have their abundance labeled. If a vector,
  only the first element is used.}

  \item{label.tips}{(Optional). Character string. Default
  is \code{NULL}, indicating that no tip labels will be
  printed. If \code{"taxa_names"}, then the name of the
  taxa will be added to the tree; either next to the
  leaves, or next to the set of points that label the
  leaves. Alternatively, if this is one of the rank names
  (from \code{rank_names(physeq)}), then the identity (if
  any) for that particular taxonomic rank is printed
  instead.}

  \item{text.size}{(Optional). Numeric. Should be positive.
  The size parameter used to control the text size of taxa
  labels. Default is \code{NULL}. If left \code{NULL}, this
  function will automatically calculate a (hopefully)
  optimal text size given the vertical constraints posed by
  the tree itself. This argument is included in case the
  automatically-calculated size is wrong, and you want to
  change it. Note that this parameter is only meaningful if
  \code{label.tips} is not \code{NULL}.}

  \item{sizebase}{(Optional). Numeric. Should be positive.
  The base of the logarithm used to scale point sizes to
  graphically represent abundance of species in a given
  sample. Default is 5.}

  \item{base.spacing}{(Optional). Numeric. Default is
  \code{0.02}. Should be positive. This defines the
  base-spacing between points at each tip/leaf in the the
  tree. The larger this value, the larger the spacing
  between points. This is useful if you have problems with
  overlapping large points and/or text indicating
  abundance, for example. Similarly, if you don't have this
  problem and want tighter point-spacing, you can shrink
  this value.}

  \item{ladderize}{(Optional). Boolean or character string
  (either \code{FALSE}, \code{TRUE}, or \code{"left"}).
  Default is \code{FALSE}. This parameter specifies whether
  or not to \code{\link[ape]{ladderize}} the tree (i.e.,
  reorder nodes according to the depth of their enclosed
  subtrees) prior to plotting. When set to \code{TRUE}, the
  default ladderization (``right'' ladderization) is used;
  when set to \code{FALSE}, no ladderization is performed;
  when set to \code{"left"}, the reverse direction
  (``left'' ladderization) is applied.}

  \item{plot.margin}{(Optional). Numeric. Default is
  \code{0.2}. Should be positive. This defines how much
  right-hand padding to add to the tree plot, which can be
  required to not truncate tip labels. The margin value is
  specified as a fraction of the overall tree width which
  is added to the right side of the plot area. So a value
  of \code{0.2} adds twenty percent extra space to the
  right-hand side of the plot.}

  \item{title}{(Optional). Default \code{NULL}. Character
  string. The main title for the graphic.}
}
\value{
  A \code{\link{ggplot}}2 plot.
}
\description{
  There are many useful examples of phyloseq tree graphics
  in the
  \href{http://joey711.github.com/phyloseq/plot_tree-examples}{phyloseq
  online tutorials}. This function is intended to
  facilitate easy graphical investigation of the
  phylogenetic tree, as well as sample data. Note that for
  phylogenetic sequencing of samples with large richness,
  some of the options in this function will be
  prohibitively slow to render, or too dense to be
  interpretable. A rough ``rule of thumb'' is to use
  subsets of data with not many more than 200 OTUs per
  plot, sometimes less depending on the complexity of the
  additional annotations being mapped to the tree. It is
  usually possible to create an unreadable, uninterpretable
  tree with modern datasets. However, the goal should be
  toward parameter settings and data subsets that convey
  (honestly, accurately) some biologically relevant feature
  of the data. One of the goals of the
  \code{\link{phyloseq-package}} is to make the
  determination of these features/settings as easy as
  possible.
}
\details{
  This function received a development contribution from
  the work of Gregory Jordan for the \code{ggphylo}
  package, which provides tools for rendering a
  phylogenetic tree in \code{\link{ggplot2}} graphics. That
  package is not currently available from CRAN or
  Bioconductor, but is available in development (roughly
  ``beta'') form from GitHub. Furthermore, although
  \code{ggphylo} awesomely supports radial and unrooted
  trees, \code{plot_tree} currently only supports
  ``standard'' square-horizontal trees. Additional support
  for these types of features (like radial trees) is
  planned. Send us development feedback if this is a
  feature you really want to have soon.
}
\examples{
# # Using plot_tree() with the esophagus dataset.
# # Please note that many more interesting examples are shown
# # in the online tutorials"
# # http://joey711.github.com/phyloseq/plot_tree-examples
data(esophagus)
plot_tree(esophagus)
plot_tree(esophagus, color="samples")
plot_tree(esophagus, size="abundance")
plot_tree(esophagus, size="abundance", color="samples")
plot_tree(esophagus, size="abundance", color="samples", base.spacing=0.03)
}
\author{
  Paul McMurdie, relying on supporting code from Gregory
  Jordan \email{gjuggler@gmail.com}
}
\seealso{
  \code{\link{plot.phylo}}

  This function is a special use-case that relies on code
  borrowed directly, with permission, from the
  not-yet-officially-released package, \code{ggphylo},
  currently only available from GitHub at:
  \url{https://github.com/gjuggler/ggphylo}

  There are many useful examples of phyloseq tree graphics
  in the
  \href{http://joey711.github.com/phyloseq/plot_tree-examples}{phyloseq
  online tutorials}.
}

