\docType{data}
\name{data-esophagus}
\alias{data-esophagus}
\alias{esophagus}
\title{(Data) Small example dataset from a human esophageal community (2004)}
\description{
  Includes just 3 samples, 1 each from 3 subjects. Although
  the research article mentions 4 subjects, only 3 are
  included in this dataset.
}
\details{
  abstract from research article (quoted):

  The esophagus, like other luminal organs of the digestive
  system, provides a potential environment for bacterial
  colonization, but little is known about the presence of a
  bacterial biota or its nature. By using broad-range 16S
  rDNA PCR, biopsies were examined from the normal
  esophagus of four human adults. The 900 PCR products
  cloned represented 833 unique sequences belonging to 41
  genera, or 95 species-level operational taxonomic units
  (SLOTU); 59 SLOTU were homologous with culture-defined
  bacterial species, 34 with 16S rDNA clones, and two were
  not homologous with any known bacterial 16S rDNA. Members
  of six phyla, Firmicutes, Bacteroides, Actinobacteria,
  Proteobacteria, Fusobacteria, and TM7, were represented.
  A large majority of clones belong to 13 of the 41 genera
  (783/900, 87\%), or 14 SLOTU (574/900, 64\%) that were
  shared by all four persons. Streptococcus (39\%),
  Prevotella (17\%), and Veilonella (14\%) were most
  prevalent. The present study identified 56-79\% of SLOTU
  in this bacterial ecosystem. Most SLOTU of esophageal
  biota are similar or identical to residents of the
  upstream oral biota, but the major distinction is that a
  large majority (82\%) of the esophageal bacteria are
  known and cultivable. These findings provide evidence for
  a complex but conserved bacterial population in the
  normal distal esophagus.

  (end quote)

  A description of the 16S rRNA sequence processing can be
  found on the mothur-wiki at the link below. A cutoff of
  0.10 was used for OTU clustering in that example, and it
  is taken here as well to create example data,
  \code{esophagus}, which was easily imported with the
  \code{import_mothur()} function.
}
\examples{
# Example using esophagus-data in a UniFrac calculation.
data(esophagus)
UniFrac(esophagus, weighted=TRUE)
UniFrac(esophagus, weighted=FALSE)
#
# How to re-create the esophagus dataset using import_mothur function
mothlist  <- system.file("extdata", "esophagus.fn.list.gz", package="phyloseq")
mothgroup <- system.file("extdata", "esophagus.good.groups.gz", package="phyloseq")
mothtree  <- system.file("extdata", "esophagus.tree.gz", package="phyloseq")
show_mothur_list_cutoffs(mothlist)
cutoff    <- "0.10"
esophman  <- import_mothur(mothlist, mothgroup, mothtree, cutoff)
identical(esophagus, esophman)
}
\author{
  Pei et al. \email{zhiheng.pei@med.nyu.edu}
}
\references{
  Pei, Z., Bini, E. J., Yang, L., Zhou, M., Francois, F., &
  Blaser, M. J. (2004). Bacterial biota in the human distal
  esophagus. Proceedings of the National Academy of
  Sciences of the United States of America, 101(12),
  4250-4255.
  \url{http://www.ncbi.nlm.nih.gov/pmc/articles/PMC384727}

  mothur-processed files and the sequence data can be
  downloaded from a zip-file, along with additional
  description, from the following URL:
  \url{http://www.mothur.org/wiki/Esophageal_community_analysis}
}
\keyword{data}

