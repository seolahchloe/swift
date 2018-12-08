// RUN: %empty-directory(%t)
// RUN: echo 'client()' >%t/main.swift
// RUN: %target-build-swift-dylib(%t/%{target-shared-library-prefix}AttrImplFP%{target-shared-library-suffix}) -module-name AttrImplFP -emit-module -emit-module-path %t/AttrImplFP.swiftmodule %S/attr_implements_fp.swift -Xfrontend -enable-operator-designated-types -Xfrontend -solver-enable-operator-designated-types
// RUN: %target-build-swift -I %t -o %t/a.out %s %t/main.swift -L %t -Xlinker -rpath -Xlinker %t -lAttrImplFP
// RUN: %target-codesign %t/a.out
// RUN: %target-codesign %t/%{target-shared-library-prefix}AttrImplFP%{target-shared-library-suffix}
// RUN: %target-run %t/a.out %t/%{target-shared-library-prefix}AttrImplFP%{target-shared-library-suffix} | %FileCheck %s
// REQUIRES: executable_test

// This test just checks that the lookup-table entries for @_implements are
// also written-to and read-from serialized .swiftmodules

import AttrImplFP

public func client() {
  precondition(compare_Cauxmparables(Fauxt.one, Fauxt.two))
  precondition(comparedAsCauxmparablesCount == 1)
  // CHECK: compared as Cauxmparables
  precondition(compare_Cauxmparables(Fauxt.one, Fauxt.nan))
  precondition(comparedAsCauxmparablesCount == 2)
  // CHECK: compared as Cauxmparables
  precondition(!compare_Cauxmparables(Fauxt.nan, Fauxt.one))
  precondition(comparedAsCauxmparablesCount == 3)
  // CHECK: compared as Cauxmparables

  precondition(compare_Fauxts(Fauxt.one, Fauxt.two))
  precondition(comparedAsFauxtsCount == 1)
  // CHECK: compared as Fauxts
  precondition(!compare_Fauxts(Fauxt.one, Fauxt.nan))
  precondition(comparedAsFauxtsCount == 2)
  // CHECK: compared as Fauxts
  precondition(!compare_Fauxts(Fauxt.nan, Fauxt.one))
  precondition(comparedAsFauxtsCount == 3)
  // CHECK: compared as Fauxts
}
