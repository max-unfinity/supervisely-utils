# docker commit c4363314200bbd611758c0a5db3e23ad42b9af7c68969ebb693198fa16caab88 mvd_train

# docker run \
#   --detach \
#   --workdir /root/volume/data/mouse/ \
#   -e PYTHONPATH="/root/supervisely" \
#   --volume ~/volume:/root/volume \
#   --entrypoint /bin/sh \
#   tmp_image \
#   -c "python make_clips.py"

# Train
# docker run \
#   --detach \
#   --workdir /root \
#   --volume ~/volume:/root/volume \
#   --shm-size=8g \
#   --entrypoint bash \
#   supervisely/mvd:dev \
#   -c "git clone https://github.com/supervisely-research/mvd && cd mvd && python run_class_finetuning.py --model vit_small_patch16_224 --data_set Kinetics-400 --nb_classes 3 --data_path /root/volume/data/mouse/ --data_root /root/volume/data/mouse/ --det_anno_path /root/volume/data/mouse/detections --finetune /root/volume/mvd_s_from_b_ckpt_399.pth --output_dir /root/volume/OUTPUT/MP_TRAIN_3_maximal_crop --input_size 224 --short_side_size 224 --opt adamw --opt_betas 0.9 0.999 --weight_decay 0.001 --batch_size 12 --update_freq 1 --num_sample 2 --save_ckpt_freq 2 --num_frames 16 --sampling_rate 2 --reprob 0.05 --mixup_prob 0.05 --lr 5e-4 --epochs 40 --warmup_epochs 2 --dist_eval --num_workers 12 --test_num_segment 1 --test_num_crop 1 --enable_deepspeed"

# Evaluate
docker run \
  --detach \
  --workdir /root \
  --volume ~/volume:/root/volume \
  --shm-size=8g \
  --network supervisely-utils_default \
  --env-file supervisely.env \
  --entrypoint bash \
  supervisely/mvd-inference:dev \
  -c "git clone https://github.com/supervisely-research/mvd && cd mvd && python evaluate_all.py" | xargs docker logs -f

# docker run \
#   --detach \
#   --workdir /root \
#   --volume ~/volume:/root/volume \
#   --shm-size=8g \
#   --entrypoint bash \
#   supervisely/mvd:dev \
#   -c "git clone https://github.com/supervisely-research/mvd && cd mvd && python run_class_finetuning.py"
