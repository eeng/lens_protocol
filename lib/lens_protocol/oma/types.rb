module LensProtocol
  module OMA
    TYPES = Hash.new { Type::String.new }.merge(
      'FTYP' => Type::Integer.new,
      'ETYP' => Type::Integer.new,
      'DBL' => Type::Numeric.new(decimals: 2),
      'HBOX' => Type::Numeric.new(decimals: 2, chiral: true),
      'VBOX' => Type::Numeric.new(decimals: 2, chiral: true),
      'CRIB' => Type::Numeric.new(decimals: 2, chiral: true),
      'FED' => Type::Numeric.new(decimals: 2, chiral: true),
      'NPD' => Type::Numeric.new(decimals: 2, chiral: true),
      'MPD' => Type::Integer.new(chiral: true),
      'IPD' => Type::Numeric.new(decimals: 2, chiral: true),
      'OCHT' => Type::Numeric.new(decimals: 2, chiral: true),
      'SEGHT' => Type::Numeric.new(decimals: 2, chiral: true),
      'LDDRSPH' => Type::Numeric.new(chiral: true),
      'LDDRCYL' => Type::Numeric.new(chiral: true),
      'LDDRAX' => Type::Numeric.new(chiral: true),
      'LDNRSPH' => Type::Numeric.new(chiral: true),
      'LDNRCYL' => Type::Numeric.new(chiral: true),
      'LDNRAX' => Type::Numeric.new(chiral: true),
      'LDADD' => Type::Numeric.new(chiral: true),
      'OPTFRNT' => Type::Numeric.new(chiral: true),
      'MINFRT' => Type::Numeric.new(chiral: true),
      'MAXFRT' => Type::Numeric.new(chiral: true),
      'CTHICK' => Type::Numeric.new(decimals: 3, chiral: true),
      'FCSGIN' => Type::Numeric.new(decimals: 2, chiral: true),
      'FCSGUP' => Type::Numeric.new(decimals: 2, chiral: true),
      'FCOCIN' => Type::Numeric.new(decimals: 2, chiral: true),
      'FCOCUP' => Type::Numeric.new(decimals: 2, chiral: true),
      'SGOCIN' => Type::Numeric.new(decimals: 2, chiral: true),
      'SGOCUP' => Type::Numeric.new(decimals: 2, chiral: true),
      'FRNT' => Type::Numeric.new(decimals: 2, chiral: true),
      'SPH' => Type::Numeric.new(decimals: 2, chiral: true),
      'CYL' => Type::Numeric.new(decimals: 2, chiral: true),
      'AX' => Type::Numeric.new(decimals: 2, chiral: true),
      'ADD' => Type::Numeric.new(decimals: 2, chiral: true),
      'MBASE' => Type::Numeric.new(decimals: 2, chiral: true),
      'LIND' => Type::Numeric.new(decimals: 3, chiral: true),
      'PRVM' => Type::Numeric.new(decimals: 2, chiral: true),
      'PRVA' => Type::Numeric.new(decimals: 1, chiral: true),
      '_PRVM1' => Type::Numeric.new(decimals: 1, chiral: true),
      '_PRVM2' => Type::Numeric.new(decimals: 1, chiral: true),
      '_PRVA1' => Type::Integer.new(chiral: true),
      '_PRVA2' => Type::Integer.new(chiral: true),
      'BCTHK' => Type::Numeric.new(decimals: 2, chiral: true),
      'BACK' => Type::Numeric.new(decimals: 2, chiral: true),
      'DIA' => Type::Numeric.new(decimals: 2, chiral: true),
      'LMATID' => Type::Integer.new(chiral: true),
      'LNAM' => Type::String.new(chiral: true),
      'LMATTYPE' => Type::String.new(chiral: true),
      'LDVEN' => Type::String.new(chiral: true),
      'LDNAM' => Type::String.new(chiral: true),
      'FWD' => Type::String.new(chiral: true),
      'OPC' => Type::String.new(chiral: true),
      'TINT' => Type::String.new(chiral: true),
      'ACOAT' => Type::String.new(chiral: true),
      '_LLVAL' => Type::Integer.new(chiral: true),
      'BVD' => Type::Integer.new(chiral: true),
      'PANTO' => Type::Integer.new(chiral: true),
      'ZTILT' => Type::Integer.new(chiral: true),
      '_CTO' => Type::Integer.new(chiral: true)
    )
  end
end
