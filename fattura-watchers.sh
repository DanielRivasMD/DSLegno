#!/bin/bash
####################################################################################################

# Launch watchexec for the Acquista folder (watching for XML changes)
# This triggers the fattura executable with the "acquista" flag
/opt/homebrew/bin/watchexec -w "$HOME/Desktop/Acquista" -- "$HOME/DSLegno/acquista.sh" &

####################################################################################################

# Launch watchexec for the Vendita folder (watching for XML changes)
# This triggers the fattura executable with the "vendita" flag
/opt/homebrew/bin/watchexec -w "$HOME/Desktop/Vendita" -- "$HOME/DSLegno/vendita.sh" &

####################################################################################################

# Wait for both background processes to continue running
wait

####################################################################################################
