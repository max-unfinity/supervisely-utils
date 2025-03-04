# docker commit c4363314200bbd611758c0a5db3e23ad42b9af7c68969ebb693198fa16caab88 mvd_train

# docker run \
#   --detach \
#   --workdir /root/volume/data/mouse/ \
#   -e PYTHONPATH="/root/supervisely" \
#   --volume ~/volume:/root/volume \
#   --entrypoint /bin/sh \
#   tmp_image \
#   -c "python make_clips.py"

docker run \
  --detach \
  --workdir /root/mvd \
  --volume ~/volume:/root/volume \
  --entrypoint python \
  --shm-size=8g \
  mvd-train \
  /root/mvd/run_class_finetuning.py \
  --model vit_small_patch16_224 \
  --data_set Kinetics-400 \
  --nb_classes 3 \
  --data_path data/mouse/ \
  --data_root data/mouse/ \
  --finetune OUTPUT/mvd_s_from_b_ckpt_399.pth \
  --log_dir OUTPUT/MP_TRAIN_3 \
  --output_dir OUTPUT/MP_TRAIN_3 \
  --input_size 224 \
  --short_side_size 224 \
  --opt adamw \
  --opt_betas 0.9 0.999 \
  --weight_decay 0.001 \
  --batch_size 12 \
  --update_freq 1 \
  --num_sample 2 \
  --save_ckpt_freq 5 \
  --num_frames 16 \
  --sampling_rate 2 \
  --reprob 0.0 \
  --lr 5e-4 \
  --epochs 100 \
  --warmup_epochs 3 \
  --dist_eval \
  --num_workers 8 \
  --test_num_segment 5 \
  --test_num_crop 3 \
  --enable_deepspeed