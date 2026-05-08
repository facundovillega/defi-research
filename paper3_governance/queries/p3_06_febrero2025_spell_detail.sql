SELECT
    call_block_time,
    call_tx_hash,
    call_tx_from,
    call_tx_to,
    what,
    addr,
    data
FROM maker_ethereum.Pot_call_file
WHERE call_tx_hash = 0x395e70dfbb3b3a23fbfd0e7a4ad659c77302e2f5923606e006e981097cc27ef9
