NLES=32 #64 #32
case=1
rewardtype=z1 # [k1,k2,k3,log,]
statetype=invariantlocalandglobalgradgrad #eps #psiomega # [enstrophy,energy,psidiag,psiomegadiag,psiomegalocal,omegalocal,invariantlocalandglobalgradgrad,invariantlocalandglobalgradgradeps] 
actiontype=CS #S
gensize=10 # 1: for postprecoess, 10 training, number of episode per generation
solver=training #postprocess
nagents=16
nconcurrent=1
IF_REWARD_CUM=1 #{0,1} # Sum of reward ar each time step 1: considers previous timesteps, 0: last time step
Tspinup=0 # Spin up time model run with NoSGS - pretraining
Thorizon=1e4 # Number of timesteps per episode
NumRLSteps=1e3 # Time step when RL network is updated
EPERU=1.0 # Episodes per update

myoutfile=${solver}_CASE${case}_N${NLES}_R${rewardtype}_S${statetype}_A${actiontype}_nAgents${nagents}_nCCjobs${nconcurrent}_CReward${IF_REWARD_CUM}_Ts${Tspinup}_Thor${Thorizon}_NumRLSteps${NumRLSteps}_EPERU${EPERU}.out

(echo ${myoutfile})>>${myoutfile}
(ps)>>${myoutfile}
(ls -ltr|tail -n 1)>>${myoutfile}
(top -b -n 1)>>${myoutfile}
(cat /proc/meminfo | grep Mem | head -n 3)>>${myoutfile}
(nvidia-smi)>>${myoutfile}


export OMP_NUM_THREADS=8

nohup python3 -u run-vracer-turb.py --case=${case} --rewardtype=${rewardtype} --statetype=${statetype} --actiontype=${actiontype} --NLES=${NLES} --gensize=${gensize} --solver=${solver} --nagents=${nagents} --nconcurrent=${nconcurrent} --IF_REWARD_CUM=${IF_REWARD_CUM} --Tspinup=${Tspinup} --Thorizon=${Thorizon} --NumRLSteps=${NumRLSteps} --EPERU=${EPERU}>>${myoutfile}&

wait

gensize=1
solver=postprocess
myoutfile=${solver}_CASE${case}_N${NLES}_R${rewardtype}_S${statetype}_A${actiontype}_nAgents${nagents}_nCCjobs${nconcurrent}_CReward${IF_REWARD_CUM}_Ts${Tspinup}_Thor${Thorizon}_NumRLSteps${NumRLSteps}_EPERU${EPERU}.out

nohup python3 -u run-vracer-turb.py --case=${case} --rewardtype=${rewardtype} --statetype=${statetype} --actiontype=${actiontype} --NLES=${NLES} --gensize=${gensize} --solver=${solver} --nagents=${nagents} --nconcurrent=${nconcurrent} --IF_REWARD_CUM=${IF_REWARD_CUM} --Tspinup=${Tspinup} --Thorizon=${Thorizon} --NumRLSteps=${NumRLSteps} --EPERU=${EPERU}>>${myoutfile}&

