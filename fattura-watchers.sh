#!/bin/bash
####################################################################################################

# Launch watchexec for the Vendita folder (watching for XML changes)
# This triggers the fattura executable with the "vendita" flag
/opt/homebrew/bin/watchexec -w "$HOME/Desktop/Vendita" "$HOME/bin/fattura --input $HOME/Desktop/Vendita/ --invoice vendita" &

####################################################################################################

# Launch watchexec for the Acquista folder (watching for XML changes)
# This triggers the fattura executable with the "acquista" flag
/opt/homebrew/bin/watchexec -w "$HOME/Desktop/Acquista" "$HOME/bin/fattura --input $HOME/Desktop/Acquista/ --invoice acquista" &

####################################################################################################

# Wait for both background processes to continue running
wait

####################################################################################################
