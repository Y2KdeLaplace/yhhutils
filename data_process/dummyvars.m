function X = dummyvars(var1,var2)
% generate interaction dummy variables
% Written by Yiheng Hu (2025.4.14)

assert(isvector(var1) && isvector(var2), '输入必须为列向量');
assert(length(var1) == length(var2), '两个变量长度必须一致');

N = length(var1);
K = max(var1);  % var1的类别数
M = max(var2);  % var2的类别数

% 将每对 (i,j) 映射到一个唯一的列索引
index = sub2ind([K, M], var1, var2);  % 得到 var1-var2 组合对应的位置

% 创建稀疏矩阵然后转为满矩阵
X = full(sparse(1:N, index, 1, N, K*M));

