MATCH path = (gene_1:Gene{ iri: $startIri })
  - [enc_1_10:enc] -> (protein_10:Protein)
  - [rel_10_10:it_wi|ortho*0..1] -> (protein_10b:Protein)
  - [participates_in_10_4:participates_in] -> (bioProc_4:BioProc)
RETURN path