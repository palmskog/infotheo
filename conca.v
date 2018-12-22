From mathcomp Require Import ssreflect ssrbool ssrfun eqtype ssrnat seq div.
From mathcomp Require Import choice fintype finfun bigop prime binomial ssralg.
From mathcomp Require Import finset fingroup finalg matrix.
Require Import Reals Fourier.
Require Import ssrR Reals_ext logb ssr_ext ssralg_ext bigop_ext Rbigop proba.
Require Import entropy proba cproba convex binary_entropy_function.
Require Import Ranalysis_ext Lra.

Set Implicit Arguments.
Unset Strict Implicit.
Import Prenex Implicits.

Local Open Scope proba_scope.
Local Open Scope entropy_scope.

Section concavity_of_entropy.

Lemma Rnonneg_convex : convex_interval (fun x => 0 <= x).
Proof.
  rewrite /convex_interval.
  move => x y t Hx Hy Ht.
  have H : 0 <= onem t by move : Ht => [] _ /onem_ge0.
  rewrite (_ : 0 = 0 + 0);
    [apply Rplus_le_compat;
     rewrite (_ : 0 = 0 * 0);
     [|by rewrite Rmult_0_r| |by rewrite Rmult_0_r]
    | by rewrite Rplus_0_r]; apply Rmult_le_compat => //=; try by apply Req_le.
  by move : Ht => [].
Qed.

Definition Rnonneg_interval := mkInterval Rnonneg_convex.

Lemma onem_eq1 : forall r : R, onem r = 1 <-> r = 0.
Proof.
  rewrite /onem; move => r; apply conj; [|by move => ->; rewrite Rminus_0_r].
  by move /Rplus_0_r_uniq /Ropp_eq_0_compat; rewrite Ropp_involutive.
Qed.

Lemma onem_01 : onem 0 = 1.
Proof. by rewrite onem_eq1. Qed.
Lemma onem_10 : onem 1 = 0.
Proof. by rewrite onem_eq0. Qed.

Lemma open_interval_convex (a b : R) (Hab : a < b) : convex_interval (fun x => a < x < b).
Proof.
  move => x y t [Hxa Hxb] [Hya Hyb] [[Haltt|Haeqt] [Htltb|Hteqb]]
   ; [
   | by rewrite {Haltt} Hteqb onem_10 mul0R addR0 mul1R; apply conj
   | by rewrite {Htltb} -Haeqt onem_01 mul0R add0R mul1R; apply conj
   | by rewrite Hteqb in Haeqt; move : Rlt_0_1 => /Rlt_not_eq].
  have H : 0 < onem t by apply onem_gt0.
  apply conj.
  - rewrite -[X in X < t * x + onem t * y]mul1R -(onemKC t) mulRDl.
    by apply ltR_add; rewrite ltR_pmul2l.
  - rewrite -[X in _ + _ < X]mul1R -(onemKC t) mulRDl.
    by apply ltR_add; rewrite ltR_pmul2l.
Qed.  

Lemma open_unit_interval_convex : convex_interval (fun x => 0 < x < 1).
Proof.
  apply /open_interval_convex /Rlt_0_1.
Qed.

Definition open_unit_interval := mkInterval open_unit_interval_convex.

Lemma pderivable_H2 : pderivable H2 (mem_interval open_unit_interval).
Proof.
move=> x /= [Hx0 Hx1].
apply derivable_pt_minus.
apply derivable_pt_opp.
apply derivable_pt_mult; [apply derivable_pt_id|apply derivable_pt_Log].
assumption.
apply derivable_pt_mult.
apply derivable_pt_Rminus.
apply derivable_pt_comp.
apply derivable_pt_Rminus.
apply derivable_pt_Log.
lra.



Lemma concavity_of_entropy_x_le_y
      (x y t : R)
      (Hx : open_unit_interval x) (Hy : open_unit_interval y) (Ht : 0 <= t <= 1)
      (Hxy : x < y)
  : concavef_leq H2 x y t.
Proof.
  eapply second_derivative_convexf => //.
  About    second_derivative_convexf.
  About Ranalysis_ext.pderivable.

Lemma concavivity_of_entropy : concavef_in open_unit_interval H2.
Proof.
  rewrite /concavef_in.
  rewrite /concavef_in /concavef_leq => x y t Hx Hy Ht.  
  eapply second_derivative_convexf.
  Focus 1.
  
  instantiate (2 := fun x => x).


  Lemma second_derivative_convexf : forall t, 0 <= t <= 1 -> convexf_leq f a b t.

  have : pderivable H2 I
  
Abort.

(*----*)
Variables (f : R -> R) (a b : R).
Let I := fun x0 => a <= x0 <= b.
Hypothesis HDf : pderivable f I.
Variable Df : R -> R.
Hypothesis DfE : forall x (Hx : I x), Df x = derive_pt f x (HDf Hx).
Hypothesis HDDf : pderivable Df I.
Variable DDf : R -> R.
Hypothesis DDfE : forall x (Hx : I x), DDf x = derive_pt Df x (HDDf Hx).
Hypothesis DDf_ge0 : forall x, I x -> 0 <= DDf x.

Definition L (x : R) := f a + (x - a) / (b - a) * (f b - f a).

Hypothesis ab : a < b.

Lemma LE x : L x = (b - x) / (b - a) * f a + (x - a) / (b - a) * f b.
Proof.
rewrite /L mulRBr [in LHS]addRA addRAC; congr (_ + _).
rewrite addR_opp -{1}(mul1R (f a)) -mulRBl; congr (_ * _).
rewrite -(mulRV (b - a)); last by rewrite subR_eq0; exact/eqP/gtR_eqF.
by rewrite -mulRBl -addR_opp oppRB addRA subRK addR_opp.
Qed.

(*----*)

End concavity_of_entropy.
(* TODO: concavity of relative entropy and of mutual information *)
