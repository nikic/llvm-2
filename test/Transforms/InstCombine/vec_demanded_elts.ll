; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

define i32 @test2(float %f) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    [[TMP5:%.*]] = fmul float [[F:%.*]], [[F]]
; CHECK-NEXT:    [[TMP21:%.*]] = bitcast float [[TMP5]] to i32
; CHECK-NEXT:    ret i32 [[TMP21]]
;
  %tmp5 = fmul float %f, %f
  %tmp9 = insertelement <4 x float> undef, float %tmp5, i32 0
  %tmp10 = insertelement <4 x float> %tmp9, float 0.000000e+00, i32 1
  %tmp11 = insertelement <4 x float> %tmp10, float 0.000000e+00, i32 2
  %tmp12 = insertelement <4 x float> %tmp11, float 0.000000e+00, i32 3
  %tmp19 = bitcast <4 x float> %tmp12 to <4 x i32>
  %tmp21 = extractelement <4 x i32> %tmp19, i32 0
  ret i32 %tmp21
}

define void @get_image() nounwind {
; CHECK-LABEL: @get_image(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = call i32 @fgetc(i8* null) #0
; CHECK-NEXT:    br i1 false, label [[BB2:%.*]], label [[BB3:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    br label [[BB3]]
; CHECK:       bb3:
; CHECK-NEXT:    unreachable
;
entry:
  %0 = call i32 @fgetc(i8* null) nounwind               ; <i32> [#uses=1]
  %1 = trunc i32 %0 to i8         ; <i8> [#uses=1]
  %tmp2 = insertelement <100 x i8> zeroinitializer, i8 %1, i32 1          ; <<100 x i8>> [#uses=1]
  %tmp1 = extractelement <100 x i8> %tmp2, i32 0          ; <i8> [#uses=1]
  %2 = icmp eq i8 %tmp1, 80               ; <i1> [#uses=1]
  br i1 %2, label %bb2, label %bb3

bb2:            ; preds = %entry
  br label %bb3

bb3:            ; preds = %bb2, %entry
  unreachable
}

; PR4340
define void @vac(<4 x float>* nocapture %a) nounwind {
; CHECK-LABEL: @vac(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    store <4 x float> zeroinitializer, <4 x float>* [[A:%.*]], align 16
; CHECK-NEXT:    ret void
;
entry:
  %tmp1 = load <4 x float>, <4 x float>* %a		; <<4 x float>> [#uses=1]
  %vecins = insertelement <4 x float> %tmp1, float 0.000000e+00, i32 0	; <<4 x float>> [#uses=1]
  %vecins4 = insertelement <4 x float> %vecins, float 0.000000e+00, i32 1; <<4 x float>> [#uses=1]
  %vecins6 = insertelement <4 x float> %vecins4, float 0.000000e+00, i32 2; <<4 x float>> [#uses=1]
  %vecins8 = insertelement <4 x float> %vecins6, float 0.000000e+00, i32 3; <<4 x float>> [#uses=1]
  store <4 x float> %vecins8, <4 x float>* %a
  ret void
}

declare i32 @fgetc(i8*)

define <4 x float> @dead_shuffle_elt(<4 x float> %x, <2 x float> %y) nounwind {
; CHECK-LABEL: @dead_shuffle_elt(
; CHECK-NEXT:    [[SHUFFLE_I:%.*]] = shufflevector <2 x float> [[Y:%.*]], <2 x float> undef, <4 x i32> <i32 0, i32 1, i32 undef, i32 undef>
; CHECK-NEXT:    [[SHUFFLE9_I:%.*]] = shufflevector <4 x float> [[X:%.*]], <4 x float> [[SHUFFLE_I]], <4 x i32> <i32 4, i32 5, i32 2, i32 3>
; CHECK-NEXT:    ret <4 x float> [[SHUFFLE9_I]]
;
  %shuffle.i = shufflevector <2 x float> %y, <2 x float> %y, <4 x i32> <i32 0, i32 1, i32 0, i32 1>
  %shuffle9.i = shufflevector <4 x float> %x, <4 x float> %shuffle.i, <4 x i32> <i32 4, i32 5, i32 2, i32 3>
  ret <4 x float> %shuffle9.i
}

define <2 x float> @test_fptrunc(double %f) {
; CHECK-LABEL: @test_fptrunc(
; CHECK-NEXT:    [[TMP1:%.*]] = insertelement <2 x double> <double undef, double 0.000000e+00>, double [[F:%.*]], i32 0
; CHECK-NEXT:    [[TMP2:%.*]] = fptrunc <2 x double> [[TMP1]] to <2 x float>
; CHECK-NEXT:    ret <2 x float> [[TMP2]]
;
  %tmp9 = insertelement <4 x double> undef, double %f, i32 0
  %tmp10 = insertelement <4 x double> %tmp9, double 0.000000e+00, i32 1
  %tmp11 = insertelement <4 x double> %tmp10, double 0.000000e+00, i32 2
  %tmp12 = insertelement <4 x double> %tmp11, double 0.000000e+00, i32 3
  %tmp5 = fptrunc <4 x double> %tmp12 to <4 x float>
  %ret = shufflevector <4 x float> %tmp5, <4 x float> undef, <2 x i32> <i32 0, i32 1>
  ret <2 x float> %ret
}

define <2 x double> @test_fpext(float %f) {
; CHECK-LABEL: @test_fpext(
; CHECK-NEXT:    [[TMP1:%.*]] = insertelement <2 x float> <float undef, float 0.000000e+00>, float [[F:%.*]], i32 0
; CHECK-NEXT:    [[TMP2:%.*]] = fpext <2 x float> [[TMP1]] to <2 x double>
; CHECK-NEXT:    ret <2 x double> [[TMP2]]
;
  %tmp9 = insertelement <4 x float> undef, float %f, i32 0
  %tmp10 = insertelement <4 x float> %tmp9, float 0.000000e+00, i32 1
  %tmp11 = insertelement <4 x float> %tmp10, float 0.000000e+00, i32 2
  %tmp12 = insertelement <4 x float> %tmp11, float 0.000000e+00, i32 3
  %tmp5 = fpext <4 x float> %tmp12 to <4 x double>
  %ret = shufflevector <4 x double> %tmp5, <4 x double> undef, <2 x i32> <i32 0, i32 1>
  ret <2 x double> %ret
}

define <4 x double> @test_shuffle(<4 x double> %f) {
; CHECK-LABEL: @test_shuffle(
; CHECK-NEXT:    [[RET1:%.*]] = insertelement <4 x double> [[F:%.*]], double 1.000000e+00, i32 3
; CHECK-NEXT:    ret <4 x double> [[RET1]]
;
  %ret = shufflevector <4 x double> %f, <4 x double> <double undef, double 1.0, double undef, double undef>, <4 x i32> <i32 0, i32 1, i32 2, i32 5>
  ret <4 x double> %ret
}

define <4 x float> @test_select(float %f, float %g) {
; CHECK-LABEL: @test_select(
; CHECK-NEXT:    [[A3:%.*]] = insertelement <4 x float> <float undef, float undef, float undef, float 3.000000e+00>, float [[F:%.*]], i32 0
; CHECK-NEXT:    [[RET:%.*]] = shufflevector <4 x float> [[A3]], <4 x float> <float undef, float 4.000000e+00, float 5.000000e+00, float undef>, <4 x i32> <i32 0, i32 5, i32 6, i32 3>
; CHECK-NEXT:    ret <4 x float> [[RET]]
;
  %a0 = insertelement <4 x float> undef, float %f, i32 0
  %a1 = insertelement <4 x float> %a0, float 1.000000e+00, i32 1
  %a2 = insertelement <4 x float> %a1, float 2.000000e+00, i32 2
  %a3 = insertelement <4 x float> %a2, float 3.000000e+00, i32 3
  %b0 = insertelement <4 x float> undef, float %g, i32 0
  %b1 = insertelement <4 x float> %b0, float 4.000000e+00, i32 1
  %b2 = insertelement <4 x float> %b1, float 5.000000e+00, i32 2
  %b3 = insertelement <4 x float> %b2, float 6.000000e+00, i32 3
  %ret = select <4 x i1> <i1 true, i1 false, i1 false, i1 true>, <4 x float> %a3, <4 x float> %b3
  ret <4 x float> %ret
}

; Check that instcombine doesn't wrongly fold away the select completely.

define <2 x i64> @PR24922(<2 x i64> %v) {
; CHECK-LABEL: @PR24922(
; CHECK-NEXT:    [[RESULT1:%.*]] = insertelement <2 x i64> [[V:%.*]], i64 0, i32 0
; CHECK-NEXT:    ret <2 x i64> [[RESULT1]]
;
  %result = select <2 x i1> <i1 icmp eq (i64 extractelement (<2 x i64> bitcast (<4 x i32> <i32 15, i32 15, i32 15, i32 15> to <2 x i64>), i64 0), i64 0), i1 true>, <2 x i64> %v, <2 x i64> zeroinitializer
  ret <2 x i64> %result
}

; The shuffle only demands the 0th (undef) element of 'out123', so everything should fold away.

define <4 x float> @inselt_shuf_no_demand(float %a1, float %a2, float %a3) {
; CHECK-LABEL: @inselt_shuf_no_demand(
; CHECK-NEXT:    ret <4 x float> undef
;
  %out1 = insertelement <4 x float> undef, float %a1, i32 1
  %out12 = insertelement <4 x float> %out1, float %a2, i32 2
  %out123 = insertelement <4 x float> %out12, float %a3, i32 3
  %shuffle = shufflevector <4 x float> %out123, <4 x float> undef, <4 x i32> <i32 0, i32 undef, i32 undef, i32 undef>
  ret <4 x float> %shuffle
}

; The shuffle only demands the 0th (undef) element of 'out123', so everything should fold away.

define <4 x float> @inselt_shuf_no_demand_commute(float %a1, float %a2, float %a3) {
; CHECK-LABEL: @inselt_shuf_no_demand_commute(
; CHECK-NEXT:    ret <4 x float> undef
;
  %out1 = insertelement <4 x float> undef, float %a1, i32 1
  %out12 = insertelement <4 x float> %out1, float %a2, i32 2
  %out123 = insertelement <4 x float> %out12, float %a3, i32 3
  %shuffle = shufflevector <4 x float> undef, <4 x float> %out123, <4 x i32> <i32 4, i32 undef, i32 undef, i32 undef>
  ret <4 x float> %shuffle
}

; The add uses 'out012' giving it multiple uses after the shuffle is transformed to also
; use 'out012'. The analysis should be able to see past that.

define <4 x i32> @inselt_shuf_no_demand_multiuse(i32 %a0, i32 %a1, <4 x i32> %b) {
; CHECK-LABEL: @inselt_shuf_no_demand_multiuse(
; CHECK-NEXT:    [[OUT0:%.*]] = insertelement <4 x i32> undef, i32 [[A0:%.*]], i32 0
; CHECK-NEXT:    [[OUT01:%.*]] = insertelement <4 x i32> [[OUT0]], i32 [[A1:%.*]], i32 1
; CHECK-NEXT:    [[FOO:%.*]] = add <4 x i32> [[OUT01]], [[B:%.*]]
; CHECK-NEXT:    ret <4 x i32> [[FOO]]
;
  %out0 = insertelement <4 x i32> undef, i32 %a0, i32 0
  %out01 = insertelement <4 x i32> %out0, i32 %a1, i32 1
  %out012 = insertelement <4 x i32> %out01, i32 %a0, i32 2
  %foo = add <4 x i32> %out012, %b
  %out0123 = insertelement <4 x i32> %foo, i32 %a1, i32 3
  %shuffle = shufflevector <4 x i32> %out0123, <4 x i32> undef, <4 x i32> <i32 0, i32 1, i32 undef, i32 undef>
  ret <4 x i32> %shuffle
}

define <4 x float> @inselt_shuf_no_demand_bogus_insert_index_in_chain(float %a1, float %a2, float %a3, i32 %variable_index) {
; CHECK-LABEL: @inselt_shuf_no_demand_bogus_insert_index_in_chain(
; CHECK-NEXT:    [[OUT12:%.*]] = insertelement <4 x float> undef, float [[A2:%.*]], i32 [[VARIABLE_INDEX:%.*]]
; CHECK-NEXT:    ret <4 x float> [[OUT12]]
;
  %out1 = insertelement <4 x float> undef, float %a1, i32 1
  %out12 = insertelement <4 x float> %out1, float %a2, i32 %variable_index ; something unexpected
  %out123 = insertelement <4 x float> %out12, float %a3, i32 3
  %shuffle = shufflevector <4 x float> %out123, <4 x float> undef, <4 x i32> <i32 0, i32 undef, i32 undef, i32 undef>
  ret <4 x float> %shuffle
}

; Test undef replacement in constant vector elements with binops.

define <3 x i8> @shuf_add(<3 x i8> %x) {
; CHECK-LABEL: @shuf_add(
; CHECK-NEXT:    [[BO:%.*]] = add <3 x i8> [[X:%.*]], <i8 undef, i8 2, i8 3>
; CHECK-NEXT:    [[R:%.*]] = shufflevector <3 x i8> [[BO]], <3 x i8> undef, <3 x i32> <i32 1, i32 undef, i32 2>
; CHECK-NEXT:    ret <3 x i8> [[R]]
;
  %bo = add nsw <3 x i8> %x, <i8 1, i8 2, i8 3>
  %r = shufflevector <3 x i8> %bo, <3 x i8> undef, <3 x i32> <i32 1, i32 undef, i32 2>
  ret <3 x i8> %r
}

define <3 x i8> @shuf_sub(<3 x i8> %x) {
; CHECK-LABEL: @shuf_sub(
; CHECK-NEXT:    [[BO:%.*]] = sub <3 x i8> <i8 1, i8 undef, i8 3>, [[X:%.*]]
; CHECK-NEXT:    ret <3 x i8> [[BO]]
;
  %bo = sub nuw <3 x i8> <i8 1, i8 2, i8 3>, %x
  %r = shufflevector <3 x i8> %bo, <3 x i8> undef, <3 x i32> <i32 0, i32 undef, i32 2>
  ret <3 x i8> %r
}

define <3 x i8> @shuf_mul(<3 x i8> %x) {
; CHECK-LABEL: @shuf_mul(
; CHECK-NEXT:    [[BO:%.*]] = mul <3 x i8> [[X:%.*]], <i8 1, i8 undef, i8 3>
; CHECK-NEXT:    [[R:%.*]] = shufflevector <3 x i8> [[BO]], <3 x i8> undef, <3 x i32> <i32 0, i32 2, i32 0>
; CHECK-NEXT:    ret <3 x i8> [[R]]
;
  %bo = mul nsw <3 x i8> %x, <i8 1, i8 2, i8 3>
  %r = shufflevector <3 x i8> %bo, <3 x i8> undef, <3 x i32> <i32 0, i32 2, i32 0>
  ret <3 x i8> %r
}

define <3 x i8> @shuf_and(<3 x i8> %x) {
; CHECK-LABEL: @shuf_and(
; CHECK-NEXT:    [[BO:%.*]] = and <3 x i8> [[X:%.*]], <i8 1, i8 2, i8 undef>
; CHECK-NEXT:    [[R:%.*]] = shufflevector <3 x i8> [[BO]], <3 x i8> undef, <3 x i32> <i32 1, i32 1, i32 0>
; CHECK-NEXT:    ret <3 x i8> [[R]]
;
  %bo = and <3 x i8> %x, <i8 1, i8 2, i8 3>
  %r = shufflevector <3 x i8> %bo, <3 x i8> undef, <3 x i32> <i32 1, i32 1, i32 0>
  ret <3 x i8> %r
}

define <3 x i8> @shuf_or(<3 x i8> %x) {
; CHECK-LABEL: @shuf_or(
; CHECK-NEXT:    [[BO:%.*]] = or <3 x i8> [[X:%.*]], <i8 1, i8 2, i8 undef>
; CHECK-NEXT:    [[R:%.*]] = shufflevector <3 x i8> [[BO]], <3 x i8> undef, <3 x i32> <i32 1, i32 undef, i32 0>
; CHECK-NEXT:    ret <3 x i8> [[R]]
;
  %bo = or <3 x i8> %x, <i8 1, i8 2, i8 3>
  %r = shufflevector <3 x i8> %bo, <3 x i8> undef, <3 x i32> <i32 1, i32 undef, i32 0>
  ret <3 x i8> %r
}

define <3 x i8> @shuf_xor(<3 x i8> %x) {
; CHECK-LABEL: @shuf_xor(
; CHECK-NEXT:    [[BO:%.*]] = xor <3 x i8> [[X:%.*]], <i8 1, i8 undef, i8 3>
; CHECK-NEXT:    [[R:%.*]] = shufflevector <3 x i8> [[BO]], <3 x i8> undef, <3 x i32> <i32 2, i32 undef, i32 0>
; CHECK-NEXT:    ret <3 x i8> [[R]]
;
  %bo = xor <3 x i8> %x, <i8 1, i8 2, i8 3>
  %r = shufflevector <3 x i8> %bo, <3 x i8> undef, <3 x i32> <i32 2, i32 undef, i32 0>
  ret <3 x i8> %r
}

define <3 x i8> @shuf_lshr_const_op0(<3 x i8> %x) {
; CHECK-LABEL: @shuf_lshr_const_op0(
; CHECK-NEXT:    [[BO:%.*]] = lshr <3 x i8> <i8 1, i8 2, i8 3>, [[X:%.*]]
; CHECK-NEXT:    [[R:%.*]] = shufflevector <3 x i8> [[BO]], <3 x i8> undef, <3 x i32> <i32 2, i32 1, i32 undef>
; CHECK-NEXT:    ret <3 x i8> [[R]]
;
  %bo = lshr <3 x i8> <i8 1, i8 2, i8 3>, %x
  %r = shufflevector <3 x i8> %bo, <3 x i8> undef, <3 x i32> <i32 2, i32 1, i32 undef>
  ret <3 x i8> %r
}

define <3 x i8> @shuf_lshr_const_op1(<3 x i8> %x) {
; CHECK-LABEL: @shuf_lshr_const_op1(
; CHECK-NEXT:    [[BO:%.*]] = lshr exact <3 x i8> [[X:%.*]], <i8 1, i8 2, i8 3>
; CHECK-NEXT:    [[R:%.*]] = shufflevector <3 x i8> [[BO]], <3 x i8> undef, <3 x i32> <i32 2, i32 1, i32 undef>
; CHECK-NEXT:    ret <3 x i8> [[R]]
;
  %bo = lshr exact <3 x i8> %x, <i8 1, i8 2, i8 3>
  %r = shufflevector <3 x i8> %bo, <3 x i8> undef, <3 x i32> <i32 2, i32 1, i32 undef>
  ret <3 x i8> %r
}

define <3 x i8> @shuf_ashr_const_op0(<3 x i8> %x) {
; CHECK-LABEL: @shuf_ashr_const_op0(
; CHECK-NEXT:    [[BO:%.*]] = lshr <3 x i8> <i8 1, i8 2, i8 3>, [[X:%.*]]
; CHECK-NEXT:    [[R:%.*]] = shufflevector <3 x i8> [[BO]], <3 x i8> undef, <3 x i32> <i32 0, i32 undef, i32 1>
; CHECK-NEXT:    ret <3 x i8> [[R]]
;
  %bo = ashr <3 x i8> <i8 1, i8 2, i8 3>, %x
  %r = shufflevector <3 x i8> %bo, <3 x i8> undef, <3 x i32> <i32 0, i32 undef, i32 1>
  ret <3 x i8> %r
}

define <3 x i8> @shuf_ashr_const_op1(<3 x i8> %x) {
; CHECK-LABEL: @shuf_ashr_const_op1(
; CHECK-NEXT:    [[BO:%.*]] = ashr exact <3 x i8> [[X:%.*]], <i8 1, i8 2, i8 3>
; CHECK-NEXT:    [[R:%.*]] = shufflevector <3 x i8> [[BO]], <3 x i8> undef, <3 x i32> <i32 0, i32 undef, i32 1>
; CHECK-NEXT:    ret <3 x i8> [[R]]
;
  %bo = ashr exact <3 x i8> %x, <i8 1, i8 2, i8 3>
  %r = shufflevector <3 x i8> %bo, <3 x i8> undef, <3 x i32> <i32 0, i32 undef, i32 1>
  ret <3 x i8> %r
}

define <3 x i8> @shuf_shl_const_op0(<3 x i8> %x) {
; CHECK-LABEL: @shuf_shl_const_op0(
; CHECK-NEXT:    [[BO:%.*]] = shl nsw <3 x i8> <i8 1, i8 2, i8 3>, [[X:%.*]]
; CHECK-NEXT:    [[R:%.*]] = shufflevector <3 x i8> [[BO]], <3 x i8> undef, <3 x i32> <i32 2, i32 undef, i32 0>
; CHECK-NEXT:    ret <3 x i8> [[R]]
;
  %bo = shl nsw <3 x i8> <i8 1, i8 2, i8 3>, %x
  %r = shufflevector <3 x i8> %bo, <3 x i8> undef, <3 x i32> <i32 2, i32 undef, i32 0>
  ret <3 x i8> %r
}

define <3 x i8> @shuf_shl_const_op1(<3 x i8> %x) {
; CHECK-LABEL: @shuf_shl_const_op1(
; CHECK-NEXT:    [[BO:%.*]] = shl nuw <3 x i8> [[X:%.*]], <i8 1, i8 2, i8 3>
; CHECK-NEXT:    [[R:%.*]] = shufflevector <3 x i8> [[BO]], <3 x i8> undef, <3 x i32> <i32 2, i32 undef, i32 0>
; CHECK-NEXT:    ret <3 x i8> [[R]]
;
  %bo = shl nuw <3 x i8> %x, <i8 1, i8 2, i8 3>
  %r = shufflevector <3 x i8> %bo, <3 x i8> undef, <3 x i32> <i32 2, i32 undef, i32 0>
  ret <3 x i8> %r
}

define <3 x i8> @shuf_sdiv_const_op0(<3 x i8> %x) {
; CHECK-LABEL: @shuf_sdiv_const_op0(
; CHECK-NEXT:    [[BO:%.*]] = sdiv exact <3 x i8> <i8 1, i8 2, i8 3>, [[X:%.*]]
; CHECK-NEXT:    [[R:%.*]] = shufflevector <3 x i8> [[BO]], <3 x i8> undef, <3 x i32> <i32 0, i32 undef, i32 1>
; CHECK-NEXT:    ret <3 x i8> [[R]]
;
  %bo = sdiv exact <3 x i8> <i8 1, i8 2, i8 3>, %x
  %r = shufflevector <3 x i8> %bo, <3 x i8> undef, <3 x i32> <i32 0, i32 undef, i32 1>
  ret <3 x i8> %r
}

define <3 x i8> @shuf_sdiv_const_op1(<3 x i8> %x) {
; CHECK-LABEL: @shuf_sdiv_const_op1(
; CHECK-NEXT:    [[BO:%.*]] = sdiv <3 x i8> [[X:%.*]], <i8 1, i8 2, i8 3>
; CHECK-NEXT:    [[R:%.*]] = shufflevector <3 x i8> [[BO]], <3 x i8> undef, <3 x i32> <i32 1, i32 undef, i32 0>
; CHECK-NEXT:    ret <3 x i8> [[R]]
;
  %bo = sdiv <3 x i8> %x, <i8 1, i8 2, i8 3>
  %r = shufflevector <3 x i8> %bo, <3 x i8> undef, <3 x i32> <i32 1, i32 undef, i32 0>
  ret <3 x i8> %r
}

define <3 x i8> @shuf_srem_const_op0(<3 x i8> %x) {
; CHECK-LABEL: @shuf_srem_const_op0(
; CHECK-NEXT:    [[BO:%.*]] = srem <3 x i8> <i8 1, i8 2, i8 3>, [[X:%.*]]
; CHECK-NEXT:    [[R:%.*]] = shufflevector <3 x i8> [[BO]], <3 x i8> undef, <3 x i32> <i32 1, i32 undef, i32 2>
; CHECK-NEXT:    ret <3 x i8> [[R]]
;
  %bo = srem <3 x i8> <i8 1, i8 2, i8 3>, %x
  %r = shufflevector <3 x i8> %bo, <3 x i8> undef, <3 x i32> <i32 1, i32 undef, i32 2>
  ret <3 x i8> %r
}

define <3 x i8> @shuf_srem_const_op1(<3 x i8> %x) {
; CHECK-LABEL: @shuf_srem_const_op1(
; CHECK-NEXT:    [[BO:%.*]] = srem <3 x i8> [[X:%.*]], <i8 1, i8 2, i8 3>
; CHECK-NEXT:    [[R:%.*]] = shufflevector <3 x i8> [[BO]], <3 x i8> undef, <3 x i32> <i32 2, i32 undef, i32 1>
; CHECK-NEXT:    ret <3 x i8> [[R]]
;
  %bo = srem <3 x i8> %x, <i8 1, i8 2, i8 3>
  %r = shufflevector <3 x i8> %bo, <3 x i8> undef, <3 x i32> <i32 2, i32 undef, i32 1>
  ret <3 x i8> %r
}

define <3 x i8> @shuf_udiv_const_op0(<3 x i8> %x) {
; CHECK-LABEL: @shuf_udiv_const_op0(
; CHECK-NEXT:    [[BO:%.*]] = udiv exact <3 x i8> <i8 1, i8 2, i8 3>, [[X:%.*]]
; CHECK-NEXT:    [[R:%.*]] = shufflevector <3 x i8> [[BO]], <3 x i8> undef, <3 x i32> <i32 2, i32 undef, i32 0>
; CHECK-NEXT:    ret <3 x i8> [[R]]
;
  %bo = udiv exact <3 x i8> <i8 1, i8 2, i8 3>, %x
  %r = shufflevector <3 x i8> %bo, <3 x i8> undef, <3 x i32> <i32 2, i32 undef, i32 0>
  ret <3 x i8> %r
}

define <3 x i8> @shuf_udiv_const_op1(<3 x i8> %x) {
; CHECK-LABEL: @shuf_udiv_const_op1(
; CHECK-NEXT:    [[BO:%.*]] = udiv <3 x i8> [[X:%.*]], <i8 1, i8 2, i8 3>
; CHECK-NEXT:    [[R:%.*]] = shufflevector <3 x i8> [[BO]], <3 x i8> undef, <3 x i32> <i32 2, i32 undef, i32 0>
; CHECK-NEXT:    ret <3 x i8> [[R]]
;
  %bo = udiv <3 x i8> %x, <i8 1, i8 2, i8 3>
  %r = shufflevector <3 x i8> %bo, <3 x i8> undef, <3 x i32> <i32 2, i32 undef, i32 0>
  ret <3 x i8> %r
}

define <3 x i8> @shuf_urem_const_op0(<3 x i8> %x) {
; CHECK-LABEL: @shuf_urem_const_op0(
; CHECK-NEXT:    [[BO:%.*]] = urem <3 x i8> <i8 1, i8 2, i8 3>, [[X:%.*]]
; CHECK-NEXT:    [[R:%.*]] = shufflevector <3 x i8> [[BO]], <3 x i8> undef, <3 x i32> <i32 2, i32 1, i32 undef>
; CHECK-NEXT:    ret <3 x i8> [[R]]
;
  %bo = urem <3 x i8> <i8 1, i8 2, i8 3>, %x
  %r = shufflevector <3 x i8> %bo, <3 x i8> undef, <3 x i32> <i32 2, i32 1, i32 undef>
  ret <3 x i8> %r
}

define <3 x i8> @shuf_urem_const_op1(<3 x i8> %x) {
; CHECK-LABEL: @shuf_urem_const_op1(
; CHECK-NEXT:    [[BO:%.*]] = urem <3 x i8> [[X:%.*]], <i8 1, i8 2, i8 3>
; CHECK-NEXT:    [[R:%.*]] = shufflevector <3 x i8> [[BO]], <3 x i8> undef, <3 x i32> <i32 undef, i32 1, i32 0>
; CHECK-NEXT:    ret <3 x i8> [[R]]
;
  %bo = urem <3 x i8> %x, <i8 1, i8 2, i8 3>
  %r = shufflevector <3 x i8> %bo, <3 x i8> undef, <3 x i32> <i32 undef, i32 1, i32 0>
  ret <3 x i8> %r
}

define <3 x float> @shuf_fadd(<3 x float> %x) {
; CHECK-LABEL: @shuf_fadd(
; CHECK-NEXT:    [[BO:%.*]] = fadd <3 x float> [[X:%.*]], <float 1.000000e+00, float 2.000000e+00, float undef>
; CHECK-NEXT:    [[R:%.*]] = shufflevector <3 x float> [[BO]], <3 x float> undef, <3 x i32> <i32 undef, i32 1, i32 0>
; CHECK-NEXT:    ret <3 x float> [[R]]
;
  %bo = fadd <3 x float> %x, <float 1.0, float 2.0, float 3.0>
  %r = shufflevector <3 x float> %bo, <3 x float> undef, <3 x i32> <i32 undef, i32 1, i32 0>
  ret <3 x float> %r
}

define <3 x float> @shuf_fsub(<3 x float> %x) {
; CHECK-LABEL: @shuf_fsub(
; CHECK-NEXT:    [[BO:%.*]] = fsub fast <3 x float> <float 1.000000e+00, float undef, float 3.000000e+00>, [[X:%.*]]
; CHECK-NEXT:    [[R:%.*]] = shufflevector <3 x float> [[BO]], <3 x float> undef, <3 x i32> <i32 undef, i32 0, i32 2>
; CHECK-NEXT:    ret <3 x float> [[R]]
;
  %bo = fsub fast <3 x float> <float 1.0, float 2.0, float 3.0>, %x
  %r = shufflevector <3 x float> %bo, <3 x float> undef, <3 x i32> <i32 undef, i32 0, i32 2>
  ret <3 x float> %r
}

define <3 x float> @shuf_fmul(<3 x float> %x) {
; CHECK-LABEL: @shuf_fmul(
; CHECK-NEXT:    [[BO:%.*]] = fmul reassoc <3 x float> [[X:%.*]], <float 1.000000e+00, float 2.000000e+00, float undef>
; CHECK-NEXT:    [[R:%.*]] = shufflevector <3 x float> [[BO]], <3 x float> undef, <3 x i32> <i32 undef, i32 1, i32 0>
; CHECK-NEXT:    ret <3 x float> [[R]]
;
  %bo = fmul reassoc <3 x float> %x, <float 1.0, float 2.0, float 3.0>
  %r = shufflevector <3 x float> %bo, <3 x float> undef, <3 x i32> <i32 undef, i32 1, i32 0>
  ret <3 x float> %r
}

define <3 x float> @shuf_fdiv_const_op0(<3 x float> %x) {
; CHECK-LABEL: @shuf_fdiv_const_op0(
; CHECK-NEXT:    [[BO:%.*]] = fdiv reassoc ninf <3 x float> <float 1.000000e+00, float undef, float 3.000000e+00>, [[X:%.*]]
; CHECK-NEXT:    [[R:%.*]] = shufflevector <3 x float> [[BO]], <3 x float> undef, <3 x i32> <i32 undef, i32 0, i32 2>
; CHECK-NEXT:    ret <3 x float> [[R]]
;
  %bo = fdiv ninf reassoc <3 x float> <float 1.0, float 2.0, float 3.0>, %x
  %r = shufflevector <3 x float> %bo, <3 x float> undef, <3 x i32> <i32 undef, i32 0, i32 2>
  ret <3 x float> %r
}

define <3 x float> @shuf_fdiv_const_op1(<3 x float> %x) {
; CHECK-LABEL: @shuf_fdiv_const_op1(
; CHECK-NEXT:    [[BO:%.*]] = fdiv nnan ninf <3 x float> [[X:%.*]], <float 1.000000e+00, float 2.000000e+00, float undef>
; CHECK-NEXT:    [[R:%.*]] = shufflevector <3 x float> [[BO]], <3 x float> undef, <3 x i32> <i32 undef, i32 1, i32 0>
; CHECK-NEXT:    ret <3 x float> [[R]]
;
  %bo = fdiv ninf nnan <3 x float> %x, <float 1.0, float 2.0, float 3.0>
  %r = shufflevector <3 x float> %bo, <3 x float> undef, <3 x i32> <i32 undef, i32 1, i32 0>
  ret <3 x float> %r
}

define <3 x float> @shuf_frem_const_op0(<3 x float> %x) {
; CHECK-LABEL: @shuf_frem_const_op0(
; CHECK-NEXT:    [[BO:%.*]] = frem nnan <3 x float> <float 1.000000e+00, float undef, float 3.000000e+00>, [[X:%.*]]
; CHECK-NEXT:    [[R:%.*]] = shufflevector <3 x float> [[BO]], <3 x float> undef, <3 x i32> <i32 undef, i32 2, i32 0>
; CHECK-NEXT:    ret <3 x float> [[R]]
;
  %bo = frem nnan <3 x float> <float 1.0, float 2.0, float 3.0>, %x
  %r = shufflevector <3 x float> %bo, <3 x float> undef, <3 x i32> <i32 undef, i32 2, i32 0>
  ret <3 x float> %r
}

define <3 x float> @shuf_frem_const_op1(<3 x float> %x) {
; CHECK-LABEL: @shuf_frem_const_op1(
; CHECK-NEXT:    [[BO:%.*]] = frem reassoc ninf <3 x float> [[X:%.*]], <float undef, float 2.000000e+00, float 3.000000e+00>
; CHECK-NEXT:    [[R:%.*]] = shufflevector <3 x float> [[BO]], <3 x float> undef, <3 x i32> <i32 1, i32 undef, i32 2>
; CHECK-NEXT:    ret <3 x float> [[R]]
;
  %bo = frem ninf reassoc <3 x float> %x, <float 1.0, float 2.0, float 3.0>
  %r = shufflevector <3 x float> %bo, <3 x float> undef, <3 x i32> <i32 1, i32 undef, i32 2>
  ret <3 x float> %r
}

;; TODO: getelementptr tests below show missing simplifications for
;; vector demanded elements on vector geps.

define i32* @gep_vbase_w_s_idx(<2 x i32*> %base) {
; CHECK-LABEL: @gep_vbase_w_s_idx(
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr i32, <2 x i32*> [[BASE:%.*]], i64 1
; CHECK-NEXT:    [[EE:%.*]] = extractelement <2 x i32*> [[GEP]], i32 1
; CHECK-NEXT:    ret i32* [[EE]]
;
  %gep = getelementptr i32, <2 x i32*> %base, i64 1
  %ee = extractelement <2 x i32*> %gep, i32 1
  ret i32* %ee
}

define i32* @gep_splat_base_w_s_idx(i32* %base) {
; CHECK-LABEL: @gep_splat_base_w_s_idx(
; CHECK-NEXT:    [[BASEVEC2:%.*]] = insertelement <2 x i32*> undef, i32* [[BASE:%.*]], i32 1
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr i32, <2 x i32*> [[BASEVEC2]], i64 1
; CHECK-NEXT:    [[EE:%.*]] = extractelement <2 x i32*> [[GEP]], i32 1
; CHECK-NEXT:    ret i32* [[EE]]
;
  %basevec1 = insertelement <2 x i32*> undef, i32* %base, i32 0
  %basevec2 = shufflevector <2 x i32*> %basevec1, <2 x i32*> undef, <2 x i32> zeroinitializer
  %gep = getelementptr i32, <2 x i32*> %basevec2, i64 1
  %ee = extractelement <2 x i32*> %gep, i32 1
  ret i32* %ee
}


define i32* @gep_splat_base_w_cv_idx(i32* %base) {
; CHECK-LABEL: @gep_splat_base_w_cv_idx(
; CHECK-NEXT:    [[BASEVEC2:%.*]] = insertelement <2 x i32*> undef, i32* [[BASE:%.*]], i32 1
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr i32, <2 x i32*> [[BASEVEC2]], <2 x i64> <i64 undef, i64 1>
; CHECK-NEXT:    [[EE:%.*]] = extractelement <2 x i32*> [[GEP]], i32 1
; CHECK-NEXT:    ret i32* [[EE]]
;
  %basevec1 = insertelement <2 x i32*> undef, i32* %base, i32 0
  %basevec2 = shufflevector <2 x i32*> %basevec1, <2 x i32*> undef, <2 x i32> zeroinitializer
  %gep = getelementptr i32, <2 x i32*> %basevec2, <2 x i64> <i64 0, i64 1>
  %ee = extractelement <2 x i32*> %gep, i32 1
  ret i32* %ee
}

define i32* @gep_splat_base_w_vidx(i32* %base, <2 x i64> %idxvec) {
; CHECK-LABEL: @gep_splat_base_w_vidx(
; CHECK-NEXT:    [[BASEVEC2:%.*]] = insertelement <2 x i32*> undef, i32* [[BASE:%.*]], i32 1
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr i32, <2 x i32*> [[BASEVEC2]], <2 x i64> [[IDXVEC:%.*]]
; CHECK-NEXT:    [[EE:%.*]] = extractelement <2 x i32*> [[GEP]], i32 1
; CHECK-NEXT:    ret i32* [[EE]]
;
  %basevec1 = insertelement <2 x i32*> undef, i32* %base, i32 0
  %basevec2 = shufflevector <2 x i32*> %basevec1, <2 x i32*> undef, <2 x i32> zeroinitializer
  %gep = getelementptr i32, <2 x i32*> %basevec2, <2 x i64> %idxvec
  %ee = extractelement <2 x i32*> %gep, i32 1
  ret i32* %ee
}


@GLOBAL = internal global i32 zeroinitializer

define i32* @gep_cvbase_w_s_idx(<2 x i32*> %base, i64 %raw_addr) {
; CHECK-LABEL: @gep_cvbase_w_s_idx(
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr i32, <2 x i32*> <i32* undef, i32* @GLOBAL>, i64 [[RAW_ADDR:%.*]]
; CHECK-NEXT:    [[EE:%.*]] = extractelement <2 x i32*> [[GEP]], i32 1
; CHECK-NEXT:    ret i32* [[EE]]
;
  %gep = getelementptr i32, <2 x i32*> <i32* @GLOBAL, i32* @GLOBAL>, i64 %raw_addr
  %ee = extractelement <2 x i32*> %gep, i32 1
  ret i32* %ee
}

define i32* @gep_cvbase_w_cv_idx(<2 x i32*> %base, i64 %raw_addr) {
; CHECK-LABEL: @gep_cvbase_w_cv_idx(
; CHECK-NEXT:    ret i32* extractelement (<2 x i32*> getelementptr (i32, <2 x i32*> <i32* @GLOBAL, i32* @GLOBAL>, <2 x i64> <i64 0, i64 1>), i32 1)
;
  %gep = getelementptr i32, <2 x i32*> <i32* @GLOBAL, i32* @GLOBAL>, <2 x i64> <i64 0, i64 1>
  %ee = extractelement <2 x i32*> %gep, i32 1
  ret i32* %ee
}


define i32* @gep_sbase_w_cv_idx(i32* %base) {
; CHECK-LABEL: @gep_sbase_w_cv_idx(
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr i32, i32* [[BASE:%.*]], <2 x i64> <i64 undef, i64 1>
; CHECK-NEXT:    [[EE:%.*]] = extractelement <2 x i32*> [[GEP]], i32 1
; CHECK-NEXT:    ret i32* [[EE]]
;
  %gep = getelementptr i32, i32* %base, <2 x i64> <i64 0, i64 1>
  %ee = extractelement <2 x i32*> %gep, i32 1
  ret i32* %ee
}

define i32* @gep_sbase_w_splat_idx(i32* %base, i64 %idx) {
; CHECK-LABEL: @gep_sbase_w_splat_idx(
; CHECK-NEXT:    [[IDXVEC2:%.*]] = insertelement <2 x i64> undef, i64 [[IDX:%.*]], i32 1
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr i32, i32* [[BASE:%.*]], <2 x i64> [[IDXVEC2]]
; CHECK-NEXT:    [[EE:%.*]] = extractelement <2 x i32*> [[GEP]], i32 1
; CHECK-NEXT:    ret i32* [[EE]]
;
  %idxvec1 = insertelement <2 x i64> undef, i64 %idx, i32 0
  %idxvec2 = shufflevector <2 x i64> %idxvec1, <2 x i64> undef, <2 x i32> zeroinitializer
  %gep = getelementptr i32, i32* %base, <2 x i64> %idxvec2
  %ee = extractelement <2 x i32*> %gep, i32 1
  ret i32* %ee
}
define i32* @gep_splat_both(i32* %base, i64 %idx) {
; CHECK-LABEL: @gep_splat_both(
; CHECK-NEXT:    [[BASEVEC2:%.*]] = insertelement <2 x i32*> undef, i32* [[BASE:%.*]], i32 1
; CHECK-NEXT:    [[IDXVEC2:%.*]] = insertelement <2 x i64> undef, i64 [[IDX:%.*]], i32 1
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr i32, <2 x i32*> [[BASEVEC2]], <2 x i64> [[IDXVEC2]]
; CHECK-NEXT:    [[EE:%.*]] = extractelement <2 x i32*> [[GEP]], i32 1
; CHECK-NEXT:    ret i32* [[EE]]
;
  %basevec1 = insertelement <2 x i32*> undef, i32* %base, i32 0
  %basevec2 = shufflevector <2 x i32*> %basevec1, <2 x i32*> undef, <2 x i32> zeroinitializer
  %idxvec1 = insertelement <2 x i64> undef, i64 %idx, i32 0
  %idxvec2 = shufflevector <2 x i64> %idxvec1, <2 x i64> undef, <2 x i32> zeroinitializer
  %gep = getelementptr i32, <2 x i32*> %basevec2, <2 x i64> %idxvec2
  %ee = extractelement <2 x i32*> %gep, i32 1
  ret i32* %ee
}

define <2 x i32*> @gep_all_lanes_undef(i32* %base, i64 %idx) {;
; CHECK-LABEL: @gep_all_lanes_undef(
; CHECK-NEXT:    [[BASEVEC:%.*]] = insertelement <2 x i32*> undef, i32* [[BASE:%.*]], i32 0
; CHECK-NEXT:    [[IDXVEC:%.*]] = insertelement <2 x i64> undef, i64 [[IDX:%.*]], i32 1
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr i32, <2 x i32*> [[BASEVEC]], <2 x i64> [[IDXVEC]]
; CHECK-NEXT:    ret <2 x i32*> [[GEP]]
;
  %basevec = insertelement <2 x i32*> undef, i32* %base, i32 0
  %idxvec = insertelement <2 x i64> undef, i64 %idx, i32 1
  %gep = getelementptr i32, <2 x i32*> %basevec, <2 x i64> %idxvec
  ret <2 x i32*> %gep
}

define i32* @gep_demanded_lane_undef(i32* %base, i64 %idx) {
; CHECK-LABEL: @gep_demanded_lane_undef(
; CHECK-NEXT:    ret i32* undef
;
  %basevec = insertelement <2 x i32*> undef, i32* %base, i32 0
  %idxvec = insertelement <2 x i64> undef, i64 %idx, i32 1
  %gep = getelementptr i32, <2 x i32*> %basevec, <2 x i64> %idxvec
  %ee = extractelement <2 x i32*> %gep, i32 1
  ret i32* %ee
}

