MATCH path = (gene_1:Gene{ iri: $startIri })
  - [enc_1_10:enc] -> (protein_10:Protein)
  - [rel_10_10:h_s_s|ortho*0..1] -> (protein_10b:Protein)
  - [cooc_wi_10_21:cooc_wi] -> (trait_21:Trait)
RETURN path