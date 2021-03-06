\docType{methods}
\name{get_taxa}
\alias{get_taxa}
\alias{get_taxa,otu_table-method}
\alias{get_taxa,phyloseq-method}
\alias{getSpecies}
\title{Returns all abundance values of sample \code{i}.}
\usage{
  get_taxa(physeq, i)

  getSpecies(physeq, i)
}
\arguments{
  \item{physeq}{(Required). \code{\link{otu_table-class}},
  or \code{\link{phyloseq-class}}.}

  \item{i}{(Required). A single sample for which you want
  to know the abundance of each species. Can be integer for
  index value, or sample name.}
}
\value{
  An integer vector of the abundance values for each
  species in \code{physeq} for sample \code{i}
}
\description{
  This is a simple accessor function for investigating a
  single sample-of-interest.
}
\examples{
data(esophagus)
sample_names(esophagus)
get_taxa(esophagus, "B")
}
\seealso{
  \code{\link{get_sample}} \code{\link{taxa_names}}
  \code{\link{sample_names}}
}

