#!/usr/bin/env python3
'''
This file is to make a minimal, non-Pytorch-Lighntning-based implementation of the training loop
'''




    def forward(self, input):
        input = input.transpose(0, 1)

        hidden_states = []

        # Encoder
        num_timesteps, batch_size, input_channels, height, width = input.size()
        input = torch.reshape(input, (-1, input_channels, height, width))
        x = self.leakyrelu_1e(self.conv_1e(input))
        x = torch.reshape(x, (num_timesteps, batch_size, x.size(1), x.size(2), x.size(3)))
        x, hidden_state = self.clstm_1e(x, None, num_timesteps)
        hidden_states.append(hidden_state)

        num_timesteps, batch_size, input_channels, height, width = x.size()
        x = torch.reshape(x, (-1, input_channels, height, width))
        x = self.leakyrelu_2e(self.conv_2e(x))
        x = torch.reshape(x, (num_timesteps, batch_size, x.size(1), x.size(2), x.size(3)))
        x, hidden_state = self.clstm_2e(x, None, num_timesteps)
        hidden_states.append(hidden_state)

        num_timesteps, batch_size, input_channels, height, width = x.size()
        x = torch.reshape(x, (-1, input_channels, height, width))
        x = self.leakyrelu_3e(self.conv_3e(x))
        x = torch.reshape(x, (num_timesteps, batch_size, x.size(1), x.size(2), x.size(3)))
        x, hidden_state = self.clstm_3e(x, None, num_timesteps)
        hidden_states.append(hidden_state)

        # Decoder
        x, hidden_state = self.clstm_1d(None, hidden_states[-1], x.size(0))
        num_timesteps, batch_size, input_channels, height, width = x.size()
        x = torch.reshape(x, (-1, input_channels, height, width))
        x = self.leakyrelu_1d(self.transconv_1d(x))
        x = torch.reshape(x, (num_timesteps, batch_size, x.size(1), x.size(2), x.size(3)))

        x, hidden_state = self.clstm_2d(None, hidden_states[-2], x.size(0))
        num_timesteps, batch_size, input_channels, height, width = x.size()
        x = torch.reshape(x, (-1, input_channels, height, width))
        x = self.leakyrelu_2d(self.transconv_2d(x))
        x = torch.reshape(x, (num_timesteps, batch_size, x.size(1), x.size(2), x.size(3)))

        x, hidden_state = self.clstm_3d(None, hidden_states[-3], x.size(0))
        num_timesteps, batch_size, input_channels, height, width = x.size()
        x = torch.reshape(x, (-1, input_channels, height, width))
        x = self.leakyrelu_3d(self.transconv_3d(x))

        x = self.transconv_4d(x)
        x = torch.reshape(x, (num_timesteps, batch_size, x.size(1), x.size(2), x.size(3)))

        # Keep only the last output for an N-to-1 scheme
        x = x[-1, :, :, :, :]  # (T, B, K, H, W) -> (B, K, H, W)
        x = self.softmax(x)

        return x
