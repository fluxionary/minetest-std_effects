#!/usr/bin/env bash
grep $(date -u -I) modpack.conf &&
    grep $(date -u -I) bleeding_effect/mod.conf &&
    grep $(date -u -I) blindness_effect/mod.conf &&
    grep $(date -u -I) builders_flight_effect/mod.conf &&
    grep $(date -u -I) burning_effect/mod.conf &&
    grep $(date -u -I) exhaustion_effect/mod.conf &&
    grep $(date -u -I) haste_effect/mod.conf &&
    grep $(date -u -I) invisibility_effect/mod.conf &&
    grep $(date -u -I) lycanthropy_effect/mod.conf &&
    grep $(date -u -I) miasma_effect/mod.conf &&
    grep $(date -u -I) nightvision_effect/mod.conf &&
    grep $(date -u -I) poison_effect/mod.conf &&
    grep $(date -u -I) regen_effect/mod.conf &&
    grep $(date -u -I) shield_effect/mod.conf &&
    grep $(date -u -I) slowness_effect/mod.conf &&
    grep $(date -u -I) strength_effect/mod.conf &&
    grep $(date -u -I) stun_effect/mod.conf &&
    grep $(date -u -I) tipsy_effect/mod.conf &&
    grep $(date -u -I) water_breathing_effect/mod.conf &&
    grep $(date -u -I) wet_effect/mod.conf
exit $?
