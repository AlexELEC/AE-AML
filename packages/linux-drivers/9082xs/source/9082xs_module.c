/*
 * Module-wrapper for SCI s9082c blob-driver.
 *
 * Copyright (C) 2019 Igor Mokrushin aka McMCC <mcmcc@mail.ru>
 *
 *    This program is free software; you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation; either version 2 of the License, or
 *    (at your option) any later version.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License along
 *    with this program; if not, write to the Free Software Foundation, Inc.,
 *    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */
#include <linux/module.h>
#include <linux/rcupdate.h>
#include <linux/cpu.h>
#include <linux/preempt.h>
#include <linux/spinlock.h>
#include <linux/bitops.h>
#include <linux/sched.h>

/*
Problem: Crash work driver after one-two minuts.
[   30.300224@0] Call trace:
[   30.302821@0] [<ffffffc001759334>] _raw_spin_lock+0x1c/0x58
[   30.308335@0] [<ffffffc0010affa0>] __queue_work+0x160/0x310
[   30.313853@0] [<ffffffc0010b01b4>] queue_work_on+0x64/0x88
[   30.319340@0] [<ffffffbffc1e86e0>] sd_dpc_init+0x108/0x340 [9082xs]
[   30.325553@0] [<ffffffbffc1e8a3c>] sd_int_handle+0x124/0x134 [9082xs]
[   30.331923@0] [<ffffffbffc1b8bbc>] sd_sync_int_handle+0x44/0x60 [9082xs]
[   30.338527@0] [<ffffffc001492568>] process_sdio_pending_irqs+0x38/0x198
[   30.345077@0] [<ffffffc0014927bc>] sdio_irq_thread+0xac/0x228
[   30.350771@0] [<ffffffc0010b9078>] kthread+0xe8/0xf0
[   30.355685@0] Code: aa0003f3 aa1e03e0 d503201f f9800271 (885ffe60)
[   30.362058@0] [sched_delayed] sched: RT throttling activated
[   30.367565@0] ---[ end trace 0021271de1c67728 ]---

Fix: Need use online core CPU for work function queue_work_on().
*/

bool Queue_work_on(int cpu, struct workqueue_struct *wq, struct work_struct *work)
{
	return queue_work_on(WORK_CPU_UNBOUND, wq, work);
}

MODULE_LICENSE("GPL");
