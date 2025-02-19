function res = Overlap_Wavelet(support_size, filterSize, wavScale)
% implements a Overlap operator for field map and wavelet for water/fat error estimates
%
% (c) Samir Sharma 2010

res.adjoint = 0;
[B, hx] = SDS_Create_BSpline(support_size);
[res.basis] = SDS_BSpline_Basis(B,hx,full_res);
res.h = daubcqf(filterSize);
res.wavScale = wavScale;

res = class(res,'Overlap_Wavelet');

