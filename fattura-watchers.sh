#!/bin/bash
####################################################################################################

# Launch watchexec for the Vendita folder (watching for XML changes)
# This triggers the fattura executable with the "vendita" flag
/usr/local/bin/watchexec -w "$HOME/Desktop/Vendita" "$HOME/bin/fattura --input $HOME/Desktop/Vendita/*.xml --invoice vendita" &

####################################################################################################

# Launch watchexec for the Acquista folder (watching for XML changes)
# This triggers the fattura executable with the "acquista" flag
/usr/local/bin/watchexec -w "$HOME/Desktop/Acquista" "$HOME/bin/fattura --input $HOME/Desktop/Acquista/*.xml --invoice acquista" &

####################################################################################################

# Wait for both background processes to continue running
wait

####################################################################################################
