# Implements auto-encoding variational Bayes.

import autograd.numpy as np
import autograd.numpy.random as npr
import autograd.scipy.stats.norm as norm

from autograd import grad
from data import load_mnist
from data import save_images as s_images
from autograd.misc import (
    flatten,
)  # This is used to flatten the params (transforms a list into a numpy array)

# images is an array with one row per image, file_name is the png file on which to save the images


def save_images(images, file_name):
    return s_images(images, file_name, vmin=0.0, vmax=1.0)


# Sigmoid activiation function to estimate probabilities


def sigmoid(x):
    return 1.0 / (1.0 + np.exp(-x))


# Relu activation function for non-linearity


def relu(x):
    return np.maximum(0, x)


# This function intializes the parameters of a deep neural network


def init_net_params(layer_sizes, scale=1e-2):
    """Initializes neural network parameters

    Args:
        layer_sizes (int): number of layers of the target NN
        scale (float, optional): Scale of the parameters. Defaults to 1e-2.

    Returns:
        list: list of the parameters returned
    """
    """Build a (weights, biases) tuples for all layers."""
    # layer_sizes is a list with the sizes of each layer

    return [
        (scale * npr.randn(m, n), scale * npr.randn(n))  # weight matrix  # bias vector
        for m, n in zip(layer_sizes[:-1], layer_sizes[1:])
    ]


# This will be used to normalize the activations of the NN

# This computes the output of a deep neuralnetwork with params a list with pairs of weights and biases


def neural_net_predict(params, inputs):
    """Pass the input through a neural network (with ReLus) using the parameters passed

    Args:
        params (list[Tuple]): Parameters to use of the neural network 
        inputs (np.ndarray[np.ndarray]): (N x D) matrix of the data

    Returns:
        np.ndarray[np.ndarray]: Output of the neural network
    """

    for W, b in params[:-1]:
        outputs = np.dot(inputs, W) + b  # linear transformation
        inputs = relu(outputs)  # nonlinear transformation

    # Last layer is linear

    outW, outb = params[-1]
    outputs = np.dot(inputs, outW) + outb

    return outputs


# This implements the reparametrization trick


def sample_latent_variables_from_posterior(encoder_output):
    """Use the reparametrization trick to generate one sample from q(z|x) per each batch datapoint

    Args:
        encoder_output (np.ndarray): Output from the encoder

    Returns:
        np.npdarray: sampled latent variables
    """ 

    # Params of a diagonal Gaussian.
    D = np.shape(encoder_output)[-1] // 2
    mean, log_std = encoder_output[:, :D], encoder_output[:, D:]

    # This is equation 15 form the given assignment
    sampled = mean + np.exp(log_std) * npr.randn(*mean.shape)

    return sampled


# This evlauates the log of the term that depends on the data


def bernoulli_log_prob(targets, logits):
    """
    Compute the log probability of the targets given the
    generator output specified in logits
    sum the probabilities across the dimensions of each image in the batch.
    The output of this function should be a vector of size the batch size

    Args:
        targets (np.ndarray): targets to apply the log prob
        logits (np.ndarray): output of the NN representing probabilities

    Returns:
        np.ndarray: log likelihood of the Bernoulli
    """   

    # logits are in R, this is the output of the neuronal network, f(z).
    # Targets must be between 0 and 1, these are the observations, x.

    # Pre-evaluate the sigmoid
    eval_sigmoid = sigmoid(logits)

    # This is equation 3 form the given assignment
    bernoulli_log_probs = np.array([
        np.sum(
            np.log(
                targets_row * eval_sigmoid_row
                + (1 - targets_row) * (1 - eval_sigmoid_row)
            )
        )
        for targets_row, eval_sigmoid_row in zip(targets, eval_sigmoid)
    ])

    return bernoulli_log_probs


# This function evaluates the KL between q and the prior


def compute_KL(q_means_and_log_stds):
    """
    Compute the KL divergence between q(z|x)
    and the prior (use a standard Gaussian for the prior)
    Uses the fact that the KL divervence is the sum of KL divergence
    of the marginals if q and p factorize
    The output of this function should be a vector of size the batch size

    Args:
        q_means_and_log_stds (np.ndarray): distribution to compute 
                                           the KL with a standard gaussian

    Returns:
        np.ndarray: KL divergence 
    """  

    D = np.shape(q_means_and_log_stds)[-1] // 2
    mean, log_std = q_means_and_log_stds[:, :D], q_means_and_log_stds[:, D:]

    # This is equation 12 form the given assignment
    kl_divergence = np.array([
        0.5 * np.sum( np.exp(2*log_std_row) + mean_row**2 - 1 - 2*log_std_row)
        for mean_row, log_std_row in zip(mean, log_std)
    ])

    return kl_divergence


# This evaluates the lower bound


def vae_lower_bound(gen_params, rec_params, data, N):
    """
    Compute a noisy estimate of the lower bound by using a single Monte Carlo sample

    Args:
        gen_params (np.ndarray): generative network params
        rec_params (np.ndarray): encoder network params
        data (np.ndarray): data matrix
        N (int): batch size, needed for precision

    Returns:
        float: Noisy ELBO
    """ 

    # 1 - compute the encoder output using neural_net_predict given the data and rec_params
    encoder_output = neural_net_predict(params=rec_params, inputs=data)
    # print('1 - encoder_output: ', encoder_output)

    # 2 - sample the latent variables associated to the batch in data
    #     (use sample_latent_variables_from_posterior and the encoder output)
    sampled_latent_variable = sample_latent_variables_from_posterior(encoder_output)
    # print('2 - sampled_latent_variable: ', sampled_latent_variable)

    # 3 - use the sampled latent variables to reconstruct the image and to compute the log_prob of the actual data
    #     (use neural_net_predict for that)
    decoder_output = neural_net_predict(
        params=gen_params, inputs=sampled_latent_variable
    )
    # print('3 - decoder_output: ', decoder_output)

    # Apply sigmoid to obtain log-probabilities 
    log_prob = bernoulli_log_prob(data, decoder_output)
    # print('3.2 - log_prob: ', log_prob)

    # 4 - compute the KL divergence between q(z|x) and the prior (use compute_KL for that)
    kl_divergence = compute_KL(encoder_output)
    # print('4 - kl_divergence: ', kl_divergence)

    # 5 - return an average estimate (per batch point) of the lower bound
    # by substracting the KL to the data dependent term
    # This is equation 12 form the given assignment
    # Multiply by N (normalization constant)
    lower_bound_estimate = N * np.mean(log_prob - kl_divergence)
    # print('5 - lower_bound_estimate: ', lower_bound_estimate)

    return lower_bound_estimate

if __name__ == "__main__":

    # Model hyper-parameters
    npr.seed(0)  # We fix the random seed for reproducibility

    latent_dim = 50
    data_dim = 784  # How many pixels in each image (28x28).
    n_units = 200
    n_layers = 2

    gen_layer_sizes = [latent_dim] + [n_units for i in range(n_layers)] + [data_dim]
    rec_layer_sizes = [data_dim] + [n_units for i in range(n_layers)] + [latent_dim * 2]

    # Training parameters
    batch_size = 200
    num_epochs = 30
    learning_rate = 0.001

    # ADAM parameters
    alpha = 1e-3
    beta_1 = 0.9
    beta_2 = 0.999
    epsilon = 1e-8

    print("Loading training data...")
    N, train_images, _, test_images, _ = load_mnist()

    # Parameters for the generator network p(x|z)
    init_gen_params = init_net_params(gen_layer_sizes)

    # Parameters for the recognition network p(z|x)
    init_rec_params = init_net_params(rec_layer_sizes)
    combined_params_init = (init_gen_params, init_rec_params)
    num_batches = int(np.ceil(len(train_images) / batch_size))

    # We flatten the parameters (transform the lists or tupples into numpy arrays)
    flattened_combined_params_init, unflat_params = flatten(combined_params_init)

    # Actual objective to optimize that receives flattened params
    def objective(flattened_combined_params):
        combined_params = unflat_params(flattened_combined_params)
        data_idx = batch
        gen_params, rec_params = combined_params

        # We binarize the data
        on = train_images[data_idx, :] > npr.uniform(
            size=train_images[data_idx, :].shape
        )
        images = train_images[data_idx, :] * 0.0
        images[on] = 1.0

        return vae_lower_bound(gen_params, rec_params, images, N)

    # Get gradients of objective using autograd.
    objective_grad = grad(objective) 
    flattened_current_params = flattened_combined_params_init
    
    # ADAM parameters
    t = 1

    # TODO write here the initial values for the ADAM parameters (including the m and v vectors)
    # you can use np.zeros_like(flattened_current_params) to initialize m and v
    m = np.zeros_like(flattened_current_params)
    v = np.zeros_like(flattened_current_params)

    # We do the actual training - ADAM optimization
    for epoch in range(num_epochs):
        elbo_est = 0.0

        #print('efore:', flattened_current_params[:3])
        for n_batch in range(int(np.ceil(N / batch_size))):
            batch = np.arange(
                batch_size * n_batch, np.minimum(N, batch_size * (n_batch + 1))
            )

            # Compute the noisy gradients
            grad = objective_grad(flattened_current_params)
            # print('1 - grad: ', grad)

            # TODO Use the estimated noisy gradient in grad to update the paramters using the ADAM updates

            # ADAM step
            m = beta_1 * m + (1 - beta_1) * grad
            v = beta_2 * v + (1 - beta_2) * grad**2
            hat_m = m / (1 - beta_1**t)
            hat_v = v / (1 - beta_2**t)
            # print('2 - hat m, v: ', hat_m, hat_v)

            flattened_current_params += alpha * hat_m / (np.sqrt(hat_v) + epsilon)
            # print('3 - flattened_current_params: ', flattened_current_params)
            elbo_est += objective(flattened_current_params)
            # print('4 - elbo_est: ', elbo_est)

            # a=a
            t += 1

        print("Epoch: %d ELBO: %e" % (epoch, elbo_est / np.ceil(N / batch_size)))

    print('Train finished! {} epochs in total.'.format(num_epochs))

    # We obtain the final trained parameters
    gen_params, rec_params = unflat_params(flattened_current_params)

    # -------------------------- TASK 3.1 --------------------------
    # TODO Generate 25 images from prior (use neural_net_predict)
    # and save them using save_images
    n_images = 25
    
    # Apply autoencoder with noise images
    sampled_z = npr.randn(25, latent_dim)
    sampled_x = neural_net_predict(gen_params, sampled_z)
    created_images = sigmoid(sampled_x)

    # Save images
    save_images(created_images, "output/3_1.png")

    # -------------------------- TASK 3.2 --------------------------
    # TODO Generate image reconstructions for the first 10 test images
    # (use neural_net_predict for each model)
    # and save them alongside with the original image using save_images

    # Obtain the images and reshape them.
    # reshaped_images = test_images[:10].reshape(-1, 28*28)

    # Apply autoencoder to obtain images reconstrucions
    encoder_output = neural_net_predict(rec_params, test_images[:10])
    sampled_z = sample_latent_variables_from_posterior(encoder_output)
    sampled_x = neural_net_predict(gen_params, sampled_z)
    reconstructed_images = sigmoid(sampled_x)

    # Concatenate images and save them
    concatenated = np.append(
        test_images[:10],
        reconstructed_images,
        axis=0
    )

    save_images(concatenated, "output/3_2.png")

    # -------------------------- TASK 3.3 --------------------------
    # TODO Generate 5 interpolations from the first test image to the second test image,
    # for the third to the fourth and so on until 5 interpolations
    # are computed in latent space and save them using save images.
    # Use a different file name to store the images of each iterpolation.
    # To interpolate from  image I to image G use a convex conbination. Namely,
    # I * s + (1-s) * G where s is a sequence of numbers from 0 to 1 obtained by numpy.linspace
    # Use mean of the recognition model as the latent representation.

    # Initialize parameters
    num_interpolations = 5
    n_interpolation_steps = 25

    for i in range(num_interpolations):
        img1, img2 = test_images[2*i: 2*i+2]

        # Obtain the latent representations of each image
        encoder_output_1 = neural_net_predict(rec_params, img1)
        encoder_output_2 = neural_net_predict(rec_params, img2)

        # Obtain the means of each representation
        D = np.shape(encoder_output_1)[-1] // 2
        mean1 = encoder_output_1[:D]
        mean2 = encoder_output_2[:D]

        # Interpolate the means
        z_interpolations = np.array([
            (1 - s) * mean1 + s * mean2
            for s in np.linspace(0.0, 1.0, num=n_interpolation_steps)
        ])

        # Obtain the interpolated images from the interpolated Z
        interpolated_imgs = np.array([
            neural_net_predict(gen_params, z)
            for z in z_interpolations
        ])

        # Save images
        save_images(sigmoid(interpolated_imgs), "output/3_3_{}.png".format(i+1))
