MATCH path = (gene_1:Gene{ iri: $startIri })
  - [enc_1_10:enc] -> (protein_10:Protein)
  - [xref_10_10_2:xref*0..2] -> (protein_10b:Protein)
  - [pub_in_10_2:pub_in] -> (publication_2:Publication)
RETURN path