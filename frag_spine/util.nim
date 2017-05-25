import
  spine

proc convertToSeq*[T, T2](ua: ptr UncheckedArray[T2], size: cint): seq[T] =
  result = @[]
  for i in 0..<size:
    result.add(
      ua.offset(i)[0].T
    )
