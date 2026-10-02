#!/bin/bash

INPUT_BASE="input"
EXE="./nga2.dp.gnu.opt.mpi.exe"
CSV_FILE="cases.csv"
CURRENT_DIR=$(pwd)
MAX_JOBS=12       # Run all 12 cases concurrently
CPUS_PER_JOB=1   # 1 core per job

{
  while IFS=',' read -r nx ny dt rea wea; do
    # Skip comment lines or header lines starting with '#' or 'nx'
    [[ "$nx" =~ ^#.* ]] && continue
    [[ "$nx" == "nx" ]] && continue

    # Clean whitespace
    nx=$(echo "$nx" | xargs)
    ny=$(echo "$ny" | xargs)
    dt=$(echo "$dt" | xargs)
    rea=$(echo "$rea" | xargs)
    wea=$(echo "$wea" | xargs)

    CASE_NAME="grid_${nx}x${ny}_Re${rea}_We${wea}"
    CASE_DIR="Cases_test/$CASE_NAME"

    mkdir -p "$CASE_DIR"
    FILE_IN="$CASE_DIR/input_used"
    cp "$INPUT_BASE" "$FILE_IN"

    # Precise replacement using exact line keys from your input file
    sed -i "s/^Base nx:.*/Base nx:   $nx/" "$FILE_IN"
    sed -i "s/^Base ny:.*/Base ny:   $ny/" "$FILE_IN"
    sed -i "s/^Max dt:.*/Max dt:   $dt/" "$FILE_IN"
    sed -i "s/^Reynolds number:.*/Reynolds number:    $rea/" "$FILE_IN"
    sed -i "s/^Weber number:.*/Weber number:       $wea/" "$FILE_IN"

    # Launch simulation in background
    (
      echo "Starting case: $CASE_NAME"
      cd "$CASE_DIR" || exit 1

      rm -rf ensight/ monitor/ log.out

      # Run job on 1 CPU
      ## mpirun -n "$CPUS_PER_JOB" "$CURRENT_DIR/$EXE" -i input_used -v 2 > log.out 2>&1
      mpirun -n "$CPUS_PER_JOB" "$CURRENT_DIR/$EXE" -i input_used -v 2 < /dev/null > log.out 2>&1

      echo "Completed case: $CASE_NAME"
    ) &

    # Throttling limit check, not needed locally
    ## while [ "$(jobs -r -p | wc -l)" -ge "$MAX_JOBS" ]; do
      ## wait -n
    ## done

  done
} < "$CSV_FILE"

wait
echo "All 12 simulations completed."
