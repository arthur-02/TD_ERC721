const ExerciceSolution = artifacts.require("ExerciceSolution");


const EvaluatorAddressSepolia1 = "0xB1BEAE84fDC2989fB9ef5C2ee8127617B17039E0";
const EvaluatorAddressSepolia2 = "0xf84BA7aD45418F36A35dfD664445D6e5fbC4f2ab";

module.exports = function (deployer, network, accounts) {
	deployer.deploy(ExerciceSolution);
};


