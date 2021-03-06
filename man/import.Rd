\name{import}
\alias{import}
\title{Universal import method (wrapper) for phyloseq-package}
\usage{
  import(pipelineName, ...)
}
\arguments{
  \item{pipelineName}{(Required). Character string. The
  name of the analysis tool / pipeline / package that
  created the OTU-cluster data or other data that you now
  want to import. Current options are \code{c("mothur",
  "pyrotagger", "QIIME", "RDP")}, and only the first letter
  is necessary.}

  \item{...}{(Required). Additional arguments providing
  file paths, and possible other paramaters to the desired
  tool-specific import function.}
}
\value{
  In most cases a \code{\link{phyloseq-class}} will be
  returned, though the included component data will vary by
  pipeline/tool, and also by the types of data files
  provided. The expected behavior is to return the
  most-comprehensive object possible, given the provided
  arguments and pipeline/tool.
}
\description{
  A user must still understand the additional arguments
  required for each type of import data. Those arguments
  are described in detail at the tool-specific
  \code{import_*} links below. Each clustering tool /
  package / pipeline has its own idiosyncratic set of file
  names / types, and it remains the responsibility of the
  user to understand which file-path should be provided to
  each argument for the particular importing submethod.
  This method merely provides a central documentation and
  method-name, and the arguments are passed along as-is.
}
\examples{
## import("QIIME", otufilename=myOtuTaxFilePath, mapfilename=myMapFilePath)
}
\references{
  mothur: \url{http://www.mothur.org/wiki/Main_Page}

  PyroTagger: \url{http://pyrotagger.jgi-psf.org/}

  QIIME: \url{http://qiime.org/}

  BIOM: \url{http://www.biom-format.org/}

  RDP pipeline: \url{http://pyro.cme.msu.edu/index.jsp}
}
\seealso{
  For mothur, see: \code{\link{import_mothur}}

  Separate tools for mothur are also:
  \code{\link{show_mothur_list_cutoffs}}
  \code{\link{import_mothur_dist}}
  \code{\link{export_mothur_dist}}

  For PyroTagger, see: \code{\link{import_pyrotagger_tab}}

  For QIIME, see: \code{\link{import_qiime}}

  For BIOM format, see: \code{\link{import_biom}}

  For RDP pipeline, see: \code{\link{import_RDP_cluster}}

  \code{\link{import_RDP_otu}}
}

