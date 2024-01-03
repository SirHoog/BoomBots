using Godot;
using System;

public partial class NeuralNetwork : AI
{
	private List<float> MatrixVectorMultiply(List<List<float>> matrix = {{}}, List<float> vector = {})
	{
		private List<float> productVector = {};
		
		if (matrix.Count == 0 || matrix.First().Count != vector.Count)
		{
			GD.Print("Error: Incompatible matrix and vector dimensions for multiplication");

			return productVector;
		};
		
		for (int i = 0; i < matrix.Count; i++)
		{
			private float rowSum = 0;

			for (int j = 0; j < vector.Count; j++)
			{
				rowSum += matrix[i][j] * vector[j];
			};
			
			productVector.Add(rowSum);
		};
		
		return productVector
	};

	private List<float> VectorAdd(List<float> vector1 = {}, List<float> vector2 = {})
	{
		List<float> addend = {};
		
		for (int i = 0; i < vector1.Count; i++)
		{
			addend.Add(vector1[i] + vector2[i]);
		};
		
		return addend;
	};
	
	private Random rand = new Random();

	private List<List<Neuron>> layers = {{}};

	public override void _Init(int RaycastsAmount = 0, int HiddenLayersAmount = 0, int HiddenLayerSize = 0, int OutputLayerSize = 0)
	{
		List<Neuron> inputLayer = {};
	
		for (int i = 0; i < RaycastsAmount * 2 + 1; i++) // `* 2` because of the distance and target type; `+ 1` because of the bias neuron
		{
			if (i == RaycastsAmount + 1) // If bias neuron
			{
				inputLayer.Add(new Neuron(1, {}, HiddenLayerSize));
			}
			else
			{
				inputLayer.Add(new Neuron(rand.Next(-1, 1), {}, HiddenLayerSize))
			};
		
			layers.Add(inputLayer);
			
			for (int i = 0; i < HiddenLayersAmount; i++)
			{
				List<Neuron> hiddenLayer = {};
				
				for (int j = 0; j < HiddenLayerSize + 1; j++)
				{
					if (i == HiddenLayersAmount): // If last hidden layer
						if (j == HiddenLayerSize + 1) // If bias neuron
						{
							hiddenLayer.Add(new Neuron(1, {}, OutputLayerSize));
						}
						else
						{
							hiddenLayer.Add(new Neuron(rand.Next(-1, 1), {}, OutputLayerSize));
						}
					else
					{
						if (j == HiddenLayerSize + 1)
						{
							hiddenLayer.Add(new Neuron(1, {}, HiddenLayerSize));
						}
						else
						{
							hiddenLayer.Add(new Neuron(rand.Next(-1, 1), {}, HiddenLayerSize));
						}
					}
				};

				layers.Add(hiddenLayer);
			};
			
			private List<Neuron> output = {};
			
			for (int i = 0; i < OutputLayerSize; i++) // No `+ 1` because the output layer has no bias neuron
			{
				outputLayer.Add(new Neuron(0, {}, 0));
			};
			
			layers.Add(outputLayer);
		}
	};

	public List<float> Update()
	{
		// Initialize input values
		for (int i = 0; i < RaycastsAmount; i++)
		{
			layers.First()[i].activation = Math.Tanh(input[i]);
		};
		
		// Feed forward / Propagate forward
		for (int i = 1; i < layers.Count; i++) // For each layer (besides input layer)
			private List<Neuron> previousLayer = layers[i - 1];
			private List<Neuron> currentLayer = layers[i];
			
			private List<List<float>> weights = {}; // Matrix
			private List<float> activations = {}; // Vector
			private List<float> biases = previousLayer[^1].weights; // Vector
			
			for (int j = 0; j < currentLayer.Count - 1; j++) // For each weight in previousLayer connecting to currentLayer # `- 1` because of bias neuron
			{
				private List<float> columnOfWeights = {};
			
				for (int k = 0; k < previousLayer.Count - 1; k++) // For each neuron in previousLayer # `- 1` because of bias neuron
				{
					columnOfWeights.Add(previousLayer[k].weights[j]);
				};
				
				weights.Add(columnOfWeights);
			};
			
			for (int j = 0; j < previousLayer.Count - 1; j++) // For each neuron in previousLayer # `- 1` because of bias neuron
			{
				activations.Add(previousLayer[j].activation);
			};
			
			// Equation: a¹=Wa⁰+b
			
			private List<float> layerActivations = VectorAdd(MatrixVectorMultiply(weights, activations), biases);
			
			// Activation function: σ(x) = tanh(x)
			for (int j = 0; j < layerActivations.Count; j++)
			{
				layerActivations[j] = Math.Tanh(layerActivations[j]);
				currentLayer[j].activation = layerActivations[j];
			}
		
		private List<float> outputActivations = {};

		foreach (Neuron neuron in layers[^1])
		{
			outputActivations.Add(neuron.activation);
		};

		return outputActivations; // Return output layer
	}
}
