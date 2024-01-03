using Godot;
using System;

public partial class Neuron
{
    private Random rand = new Random();

    private float activation = rand.Next(-1, 1);
    private List<float> weights = {};

    public override _Init(float _activation = rand.Next(-1, 1), List<float> _weights = {}, int weightsCount = 0)
    {
        activation = _activation;
        
        if (weightsCount != 0)
        {
            for i in range(weightsCount)
            {
                weights.append(randf_range(-1, 1));
            }
        }
        else
        {
            weights = _weights;
        }
    }
}