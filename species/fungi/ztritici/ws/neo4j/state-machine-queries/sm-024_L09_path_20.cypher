MATCH path = (gene_1:Gene{ iri: $startIri })
  - [enc_1_10:enc] - (protein_10:Protein)
  - [xref_10_10_2:xref*0..2] - (protein_10b:Protein)
  - [is_a_10_16:is_a] - (enzyme_16:Enzyme)
  - [ca_by_16_18:ca_by] - (reaction_18:Reaction)
  - [part_of_18_20:part_of] - (path_20:Path)
RETURN path