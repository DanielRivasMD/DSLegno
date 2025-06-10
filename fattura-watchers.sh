#!/bin/bash
####################################################################################################

# Launch watchexec for the Acquista folder (watching for XML changes)
# This triggers the fattura executable with the "acquista" flag
/opt/homebrew/bin/watchexec -w "$HOME/Desktop/Acquista" -- bash -c "for file in '$HOME/Desktop/Acquista'/*.xml; do '$HOME/bin/fattura' --input \"\$file\" --invoice acquista; done" &

####################################################################################################

# Launch watchexec for the Vendita folder (watching for XML changes)
# This triggers the fattura executable with the "vendita" flag
/opt/homebrew/bin/watchexec -w "$HOME/Desktop/Vendita" -- bash -c "for file in '$HOME/Desktop/Vendita'/*.xml; do '$HOME/bin/fattura' --input \"$\file\" --invoice vendita; done" &

####################################################################################################

# Wait for both background processes to continue running
wait

####################################################################################################
