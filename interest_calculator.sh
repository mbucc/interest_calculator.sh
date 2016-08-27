#! /bin/sh -e
# Compute monthly and annual compound interest rate.
# Created on 8/27/2016 by Mark Bucciarelli <mkbucc@gmail.com>

usage() {
	printf "$(basename $0) <STARTING_BALANCE> <ENDING_BALANCE> <NUMBER_OF_MONTHS>\n" >&2
	exit 1
}

[ "x$1" = "x" ] && usage
[ "x$2" = "x" ] && usage
[ "x$3" = "x" ] && usage

STARTING_BALANCE=$1
ENDING_BALANCE=$2
NUMBER_OF_MONTHS=$3

#
#		rate = (end/start)^(1/n) - 1
#
#	bc does not handle non-integer exponents. But its exponential function
#	does, so we need to use the relation
#
#		x^y = e^(y * ln(x))
#
#	to calculate interest rate like so:
#
#		rate	= (end/start)^(1/n) - 1
#
#			= e( (1/n) * ln(end/start) )  - 1
#

DELTA=$(echo "$ENDING_BALANCE - $STARTING_BALANCE" | bc)
RATIO=$(echo "scale=5;$ENDING_BALANCE/$STARTING_BALANCE" | bc)
M=$(echo "e((1/$NUMBER_OF_MONTHS) * l($RATIO)) - 1" |bc -l)
Y=$(echo "(1 + $M)^12 - 1" | bc)

MPERCENT=$(echo "$M*100" |bc)
YPERCENT=$(echo "$Y*100" |bc)

printf "Starting balance = %.2f\n" $STARTING_BALANCE
printf "Ending balance   = %.2f\n" $ENDING_BALANCE
printf "Number of months = %d\n" $NUMBER_OF_MONTHS
printf "    --> change in principle    = %12.2f\n" $DELTA
printf "        monthly interest rate  = %12.2f%%\n" $MPERCENT
printf "        annual interest rate   = %11.1f%%\n" $YPERCENT
