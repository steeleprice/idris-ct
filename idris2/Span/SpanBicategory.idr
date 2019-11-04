module Span.SpanBicategory

import Basic.Category
import Basic.Functor
import CoLimits.CoLimit
import Data.List.Elem
import Dual.DualCategory
import Free.Path
import Higher.Bicategory
import Limits.Pullback
import Product.ProductCategory
import Span.Span
import Span.SpanCategory

public export
spanHorizontalCompositionObj : {cat : Category}
                            -> {x, y, z : obj cat}
                            -> HasPullbacks cat
                            -> (Span {cat} x y, Span {cat} y z)
                            -> Span {cat} x z
spanHorizontalCompositionObj {cat} {x} {y} {z} hasPullbacks (a, b) =
  let
    pullback = hasPullbacks (mapObj (fst a) Z)
                            (mapObj (fst b) Z)
                            y
                            (castMor Refl (snd $ snd a) $ mapMor (fst a) Z Y [There Here])
                            (castMor Refl (fst $ snd b) $ mapMor (fst b) Z X [Here])
  in
    span {cat}
        x
        z
        (carrier pullback)
        (compose cat (carrier pullback)
                     (mapObj (fst a) Z)
                     x
                     (component (cocone pullback) X)
                     (castMor Refl (fst $ snd a) (mapMor (fst a) Z X [Here])))
        (compose cat (carrier pullback)
                     (mapObj (fst b) Z)
                     z
                     (component (cocone pullback) Y)
                     (castMor Refl (snd $ snd b) (mapMor (fst b) Z Y [There Here])))

public export
spanHorizontalCompositionMor : {cat : Category}
                            -> {x, y, z : obj cat}
                            -> (hasPullbacks : HasPullbacks cat)
                            -> (a, b : (Span {cat} x y, Span {cat} y z))
                            -> ProductMorphism (SpanCategory {cat} x y) (SpanCategory {cat} y z) a b
                            -> SpanMorphism {cat} {a=x} {b=z} (spanHorizontalCompositionObj {cat} {x} {y} {z} hasPullbacks a)
                                                              (spanHorizontalCompositionObj {cat} {x} {y} {z} hasPullbacks b)
spanHorizontalCompositionMor {cat} {x} {y} {z} hasPullbacks a b (MkProductMorphism f1 f2) =
  (  MkNaturalTransformation
       (\c => case c of
               X => rewrite fst $ snd (spanHorizontalCompositionObj hasPullbacks a) in
                    rewrite fst $ snd (spanHorizontalCompositionObj hasPullbacks b) in
                      identity cat x
               Y => rewrite snd $ snd (spanHorizontalCompositionObj hasPullbacks a) in
                    rewrite snd $ snd (spanHorizontalCompositionObj hasPullbacks b) in
                      identity cat z
               Z => let
                      aPullback = hasPullbacks (mapObj {cat1=SpanIndexCategory} {cat2=cat} (fst $ fst a) Z)
                                               (mapObj {cat1=SpanIndexCategory} {cat2=cat} (fst $ snd a) Z)
                                               y
                                               (castMor Refl (snd $ snd $ fst a) $ mapMor {cat1=SpanIndexCategory} {cat2=cat} (fst $ fst a) Z Y [There Here])
                                               (castMor Refl (fst $ snd $ snd a) $ mapMor {cat1=SpanIndexCategory} {cat2=cat} (fst $ snd a) Z X [Here])
                      bPullback = hasPullbacks (mapObj {cat1=SpanIndexCategory} {cat2=cat} (fst $ fst b) Z)
                                               (mapObj {cat1=SpanIndexCategory} {cat2=cat} (fst $ snd b) Z)
                                               y
                                               (castMor Refl (snd $ snd $ fst b) $ mapMor {cat1=SpanIndexCategory} {cat2=cat} (fst $ fst b) Z Y [There Here])
                                               (castMor Refl (fst $ snd $ snd b) $ mapMor {cat1=SpanIndexCategory} {cat2=cat} (fst $ snd b) Z X [Here])
                      coSpan = span {cat = dualCategory cat}
                                   (mapObj {cat1=SpanIndexCategory} {cat2=cat} (fst $ fst b) Z)
                                   (mapObj {cat1=SpanIndexCategory} {cat2=cat} (fst $ snd b) Z)
                                   y
                                   (castMor Refl (snd $ snd $ fst b) $ mapMor {cat1=SpanIndexCategory} {cat2=cat} (fst $ fst b) Z Y [There Here])
                                   (castMor Refl (fst $ snd $ snd b) $ mapMor {cat1=SpanIndexCategory} {cat2=cat} (fst $ snd b) Z X [Here])
                      -- cone : NaturalTransformation SpanIndexCategory cat (Delta SpanIndexCategory cat (carrier aPullback)) (fst coSpan)
                      -- cone = MkNaturalTransformation ?comp ?comm
                      -- coconeMorph = exists bPullback (carrier aPullback) dCocone
                    in ?asdf3)
       ?poiu
  ** ?qwer
  ** ?zxcv)

public export
spanHorizontalComposition : {cat : Category}
                         -> {x, y, z : obj cat}
                         -> HasPullbacks cat
                         -> CFunctor (productCategory (SpanCategory {cat} x y) (SpanCategory {cat} y z))
                                     (SpanCategory {cat} x z)
spanHorizontalComposition {cat} {x} {y} {z} hasPullbacks = MkCFunctor
  (spanHorizontalCompositionObj {cat} {x} {y} {z} hasPullbacks)
  (spanHorizontalCompositionMor {cat} {x} {y} {z} hasPullbacks)
  ?pId
  ?pComp

public export
spanBicategory : (cat : Category)
              -> HasPullbacks cat
              -> Bicategory
spanBicategory cat hasPullbacks = MkBicategory
  (obj cat)
  (SpanCategory {cat})
  (\x => span x x x (identity cat x) (identity cat x))
  (spanHorizontalComposition hasPullbacks)
  ?e
  ?f
  ?g