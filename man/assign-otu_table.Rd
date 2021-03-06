\docType{methods}
\name{otu_table<-}
\alias{assign-otu_table}
\alias{otu_table<-}
\alias{otu_table<-,otu_table,otu_table-method}
\alias{otu_table<-,phyloseq,otu_table-method}
\alias{otu_table<-,phyloseq,phyloseq-method}
\alias{otuTable<-}
\title{Assign a new OTU Table to \code{x}}
\usage{
  otu_table(x) <- value
}
\arguments{
  \item{x}{(Required). \code{\link{phyloseq-class}}}

  \item{value}{(Required). \code{\link{otu_table-class}} or
  \code{\link{phyloseq-class}}.}
}
\description{
  Assign a new OTU Table to \code{x}
}
\examples{
# data(GlobalPatterns)
# # An example of pruning to just the first 100 taxa in GlobalPatterns.
# ex2a <- prune_species(taxa_names(GlobalPatterns)[1:100], GlobalPatterns)
# # The following 3 lines produces an ex2b that is equal to ex2a
# ex2b <- GlobalPatterns
# OTU <- otu_table(GlobalPatterns)[1:100, ]
# otu_table(ex2b) <- OTU
# identical(ex2a, ex2b)
# print(ex2b)
# # Relace otu_table by implying the component in context.
# ex2c <- GlobalPatterns
# otu_table(ex2c) <- ex2b
# identical(ex2a, ex2c)
}

