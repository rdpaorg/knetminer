//var data_url = "https://ondex.rothamsted.ac.uk/humanDisease_data/";
//var data_url = "http://knetminer.rothamsted.ac.uk/humanDisease_data/";
var data_url = "http://qtlnetminer-test.rothamsted.ac.uk/humanDisease_data/"; // now, using HTTP instead of HTTPS
//var data_url = "http://maize-dev.rothamsted.ac.uk/humanDisease_data/"; // test on maize-dev
var applet_url = "https://ondex.rothamsted.ac.uk/OndexWebBeta/";
var species = "DiseaseKnetMiner Human";
var reference_genome = true; //true if you are providing a reference genome
var multiorganisms = false; //true if you specified more than one taxid in the server file config.xml (ie: <entry key="SpeciesTaxId">4113,4081</entry>)
var species_name = 'DiseaseKnetMiner-Human';