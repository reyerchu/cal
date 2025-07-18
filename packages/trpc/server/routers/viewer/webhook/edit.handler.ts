import {
  updateTriggerForExistingBookings,
  deleteWebhookScheduledTriggers,
} from "@calcom/features/webhooks/lib/scheduleTrigger";
import { prisma } from "@calcom/prisma";
import type { TrpcSessionUser } from "@calcom/trpc/server/types";

import { TRPCError } from "@trpc/server";

import type { TEditInputSchema } from "./edit.schema";

type EditOptions = {
  ctx: {
    user: NonNullable<TrpcSessionUser>;
  };
  input: TEditInputSchema;
};

export const editHandler = async ({ input, ctx }: EditOptions) => {
  const { id, ...data } = input;

  const webhook = await prisma.webhook.findUnique({
    where: {
      id,
    },
  });

  if (!webhook) {
    return null;
  }

  if (webhook.platform) {
    const { user } = ctx;
    if (user?.role !== "ADMIN") {
      throw new TRPCError({ code: "UNAUTHORIZED" });
    }
  }

  const updatedWebhook = await prisma.webhook.update({
    where: {
      id,
    },
    data: {
      ...data,
      time: data.time ?? null,
      timeUnit: data.timeUnit ?? null,
    },
  });

  if (data.active) {
    const activeTriggersBefore = webhook.active ? webhook.eventTriggers : [];
    await updateTriggerForExistingBookings(webhook, activeTriggersBefore, updatedWebhook.eventTriggers);
  } else if (!data.active && webhook.active) {
    await deleteWebhookScheduledTriggers({ webhookId: webhook.id });
  }

  return updatedWebhook;
};
